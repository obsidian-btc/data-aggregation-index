module DataAggregation::Index
  module EventList
    class UpdateIndex
      include StreamName
      include Log::Dependency

      attr_reader :event_added
      attr_reader :category
      attr_reader :event_list_position

      dependency :clock, Clock::UTC
      dependency :get_positions, Queries::GetPositions
      dependency :writer, EventStore::Messaging::Writer

      def initialize(event_added, category, event_list_position)
        @event_added = event_added
        @event_list_position = event_list_position
        @category = category
      end

      def self.build(event_added, event_data, session: nil)
        event_list_position = event_data.number
        update_stream_name = event_data.stream_name
        category = StreamName.get_category update_stream_name

        instance = new event_added, category, event_list_position
        Clock::UTC.configure instance
        Queries::GetPositions.configure instance, session: session
        EventStore::Messaging::Writer.configure instance, session: session
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        log_attributes = "EntityID: #{entity_id}, Category: #{category}, EventID: #{event_id}, EventListPosition: #{event_list_position}"
        logger.trace "Starting update for event (#{log_attributes})"

        stream_name = index_stream_name entity_id, category

        index_pos, event_list_pos, reference_list_pos = get_positions.(entity_id, category)

        if event_list_pos == :no_stream
          next_event_list_pos = 0
        else
          next_event_list_pos = event_list_pos + 1
        end

        if next_event_list_pos > event_list_position
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
