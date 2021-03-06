module DataAggregation::Index
  module Update
    class Start
      include Log::Dependency
      include StreamName

      attr_reader :category
      attr_reader :update_started

      dependency :clock, Clock::UTC
      dependency :update_store, Update::Store
      dependency :write, Messaging::EventStore::Write

      def initialize(update_started, category)
        @update_started = update_started
        @category = category
      end

      def self.build(update_started, session: nil)
        stream_name = update_started.metadata.stream_name
        category = StreamName.get_category stream_name

        instance = new update_started, category
        Clock::UTC.configure instance
        Update::Store.configure instance, category, session: session, attr_name: :update_store
        Messaging::EventStore::Write.configure instance, session: session
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        update_id = update_started.update_id

        log_attributes = "UpdateID: #{update_id}, Category: #{category}, EntityID: #{update_started.entity_id}, EventListPosition: #{update_started.event_list_position}, ReferenceListPosition: #{update_started.reference_list_position}"
        logger.trace "Recording update has started (#{log_attributes})"

        entity, version = update_store.get update_id, include: :version

        if entity.started?
          logger.debug "Update started has already been recorded; skipped (#{log_attributes})"
          return
        end

        started = Update::Messages::Started.follow(
          update_started,
          include: %i(update_id event_list_position reference_list_position)
        )
        started.time = clock.iso8601

        stream_name = update_stream_name update_id, category

        write.(started, stream_name, expected_version: version)

        logger.debug "Update started recorded (#{log_attributes})"

        started
      end
    end
  end
end
