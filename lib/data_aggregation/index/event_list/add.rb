module DataAggregation::Index
  module EventList
    class Add
      include StreamName
      include Telemetry::Logger::Dependency

      attr_reader :category
      attr_reader :publish_event_initiated

      dependency :clock, Clock::UTC
      dependency :get_recent_event, Queries::GetRecentFact
      dependency :writer, EventStore::Messaging::Writer

      def initialize(publish_event_initiated, category)
        @publish_event_initiated = publish_event_initiated
        @category = category
      end

      def self.build(publish_event_initiated, event_data)
        update_stream_name = event_data.stream_name
        category = StreamName.get_category update_stream_name

        instance = new publish_event_initiated, category
        Clock::UTC.configure instance
        Queries::GetRecentFact.configure instance, QueryProjection, attr_name: :get_recent_event
        EventStore::Messaging::Writer.configure instance
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        log_attributes = "EntityID: #{entity_id}, EventID: #{event_id}, StartingPosition: #{starting_position}, Category: #{category}"
        logger.trace "Adding event to event list (#{log_attributes})"

        stream_name = event_list_stream_name entity_id, category

        version = get_recent_event.(stream_name, event_id, starting_position) do
          logger.debug "Event already added to event list; skipped (#{log_attributes})"
          return
        end

        event_added = Messages::Added.proceed(
          publish_event_initiated,
          include: %i(entity_id event_id event_data_text)
        )

        if version == :no_stream
          event_added.position = 0
        else
          event_added.position = version + 1
        end

        event_added.time = clock.iso8601

        writer.write event_added, stream_name, expected_version: version

        logger.debug "Event added to event list (#{log_attributes})"

        event_added
      end

      def entity_id
        publish_event_initiated.entity_id
      end

      def event_id
        publish_event_initiated.event_id
      end

      def event_data_text
        publish_event_initiated.event_data_text
      end

      def starting_position
        publish_event_initiated.event_list_position
      end

      class QueryProjection
        include EventStore::EntityProjection

        apply Messages::Added do |added|
          entity << added.event_id
        end
      end
    end
  end
end
