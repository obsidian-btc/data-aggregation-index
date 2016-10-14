module DataAggregation::Index
  module Update
    class CopyBatch
      include StreamName
      include Telemetry::Logger::Dependency

      attr_reader :batch_assembled
      attr_reader :category

      dependency :clock, Clock::UTC
      dependency :copy, Copy
      dependency :store, Store
      dependency :writer, EventStore::Messaging::Writer

      def initialize(batch_assembled, category)
        @batch_assembled = batch_assembled
        @category = category
      end

      def self.build(event, event_data)
        stream_name = event_data.stream_name
        category = StreamName.get_category stream_name

        instance = new event, category
        instance.configure
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def configure
        update_category = self.update_category category
        Store.configure self, update_category

        Clock::UTC.configure self
        Copy.configure self, entity
        EventStore::Messaging::Writer.configure self
      end

      def call
        log_attributes = "UpdateID: #{update_id}, Category: #{category}, CopyPosition: #{copy_position.inspect}, BatchPosition: #{batch_position.inspect}"
        logger.trace "Copying batch (#{log_attributes})"

        if copy_position && copy_position >= batch_position
          logger.debug "Batch already copied; skipped (#{log_attributes})"
          return
        end

        copy_position = entity.copy_position

        batch_assembled.batch_data.each do |data|
          begin
            copy.(data)
            copy_position ||= -1
            copy_position += 1
          rescue EventStore::CopyMessage::MessageOrderError
            break
          end
        end

        batch_copied = Messages::BatchCopied.proceed batch_assembled, include: :update_id
        batch_copied.copy_position = copy_position
        batch_copied.time = clock.iso8601

        stream_name = update_stream_name update_id, category
        writer.write batch_copied, stream_name, expected_version: version

        logger.debug "Batch copied (#{log_attributes})"

        batch_copied
      end

      def entity
        entity, _ = store_record
        entity
      end

      def version
        _, version = store_record
        version
      end

      def update_id
        batch_assembled.update_id
      end

      def batch_position
        batch_assembled.batch_position
      end

      def copy_position
        entity.copy_position
      end

      def batch_data
        batch_assembled.batch_data
      end

      def store_record
        @store_record ||= store.get batch_assembled.update_id, include: :version
      end
    end
  end
end
