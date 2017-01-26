module DataAggregation::Index
  module Update
    class GetNextBatch
      include StreamName
      include Log::Dependency

      dependency :clock, Clock::UTC
      dependency :query, Query
      dependency :session, EventSource::EventStore::HTTP::Session
      dependency :store, Store
      dependency :write, Messaging::EventStore::Write

      attr_writer :batch_size
      attr_reader :category
      attr_reader :event

      def initialize(event, category)
        @category = category
        @event = event
      end

      def self.build(event, event_data, session: nil)
        stream_name = event_data.stream_name
        category = StreamName.get_category stream_name

        instance = new event, category

        session = EventSource::EventStore::HTTP::Session.configure instance, session: session

        Clock::UTC.configure instance
        Store.configure instance, category, session: session
        Query.configure instance, instance.entity, category, session: session
        Messaging::EventStore::Write.configure instance, session: session

        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        log_attributes = "UpdateID: #{update_id}, Type: #{entity.type}, EntityID: #{entity.entity_id}, UpdateProgress: #{entity.copy_position.inspect}/#{entity.batch_position.inspect}/#{entity.list_position.inspect}, Batch: #{event.copy_position.inspect}-#{ending_position.inspect}"
        logger.trace "Getting next batch (#{log_attributes})"

        stream_name = update_stream_name update_id, category

        if entity.completed?
          logger.debug "Batch already completed; skipped (#{log_attributes})"
          return
        end

        if entity.finished?
          completed = Messages::Completed.proceed event, include: :update_id
          completed.time = clock.iso8601

          write.(completed, stream_name, expected_version: version)

          logger.info "Update completed (#{log_attributes})"
          return
        end

        if entity.batch_position && entity.batch_position >= starting_position
          logger.debug "Batch already assembled; skipped (#{log_attributes})"
          return
        end

        batch_data = query.(entity.entity_id, starting_position, ending_position)

        if batch_data.empty?
          error_message = "Update not finished but database returned nothing (#{log_attributes})"
          logger.error error_message
          raise EmptyRead, error_message
        end

        batch_assembled = Messages::BatchAssembled.proceed event, include: :update_id
        batch_assembled.batch_position = ending_position
        batch_assembled.batch_data = batch_data
        batch_assembled.time = clock.iso8601

        write.(batch_assembled, stream_name, expected_version: version)

        logger.debug "Get next batch done (#{log_attributes})"

        batch_assembled
      end

      def finished?
        entity.finished?
      end

      def starting_position
        if event.copy_position
          event.copy_position + 1
        else
          0
        end
      end

      def ending_position
        return if entity.list_position.nil?

        [
          starting_position + batch_size - 1,
          entity.list_position
        ].min
      end

      def batch_size
        @batch_size ||= Defaults.batch_size
      end

      def update_id
        event.update_id
      end

      def entity
        entity, _ = store_record
        entity
      end

      def version
        _, version = store_record
        version
      end

      def store_record
        @store_record ||= store.get update_id, include: :version
      end

      EmptyRead = Class.new StandardError

      module Defaults
        def self.batch_size
          env_value = ENV['DATA_AGGREGATION_UPDATE_BATCH_SIZE']

          if env_value.nil?
            25
          else
            env_value.to_i
          end
        end
      end
    end
  end
end
