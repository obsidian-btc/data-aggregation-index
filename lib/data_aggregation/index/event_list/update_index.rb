module DataAggregation::Index
  module EventList
    class UpdateIndex
      include StreamName
      include Telemetry::Logger::Dependency

      attr_reader :event_added
      attr_reader :category

      dependency :clock, Clock::UTC
      dependency :get_positions, Queries::GetPositions
      dependency :writer, EventStore::Messaging::Writer

      def initialize(event_added, category)
        @event_added = event_added
        @category = category
      end

      def self.build(event_added, event_data)
        update_stream_name = event_data.stream_name
        category = StreamName.get_category update_stream_name

        instance = new event_added, category
        Clock::UTC.configure instance
        Queries::GetPositions.configure instance
        EventStore::Messaging::Writer.configure instance
        instance
      end

      def call
        log_attributes = "EntityID: #{entity_id}, Category: #{category}, EventID: #{event_id}, EventAddedPosition: #{event_added.position}"
        logger.trace "Starting update for event (#{log_attributes})"

        stream_name = index_stream_name entity_id, category

        index_pos, event_list_pos, reference_list_pos = get_positions.(entity_id, category)

        if event_list_pos == :no_stream
          next_event_list_pos = 0
        else
          next_event_list_pos = event_list_pos + 1
        end

        if next_event_list_pos > event_added.position
          logger.debug "Update already started for event; skipped (#{log_attributes}, NextEventListPosition: #{next_event_list_pos})"
          return
        end

        update_started = DataAggregation::Index::Messages::UpdateStarted.proceed event_added, include: :entity_id
        update_started.update_id = event_id
        update_started.event_list_position = next_event_list_pos
        update_started.reference_list_position = reference_list_pos unless reference_list_pos == :no_stream
        update_started.time = clock.iso8601

        writer.write update_started, stream_name, expected_version: index_pos

        logger.debug "Update started for event (#{log_attributes}, NextEventListPosition: #{next_event_list_pos})"

        update_started
      end

      def entity_id
        event_added.entity_id
      end

      def event_id
        event_added.event_id
      end
    end
  end
end
