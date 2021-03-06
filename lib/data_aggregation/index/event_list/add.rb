module DataAggregation::Index
  module EventList
    class Add
      include StreamName
      include Log::Dependency

      attr_reader :category
      attr_reader :publish_event_initiated

      dependency :clock, Clock::UTC
      dependency :write, Messaging::EventStore::Write

      def initialize(publish_event_initiated, category)
        @publish_event_initiated = publish_event_initiated
        @category = category
      end

      def self.build(publish_event_initiated, session: nil)
        update_stream_name = publish_event_initiated.metadata.stream_name
        category = StreamName.get_category update_stream_name

        instance = new publish_event_initiated, category
        Clock::UTC.configure instance
        Messaging::EventStore::Write.configure instance, session: session
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        log_attributes = "EntityID: #{entity_id}, EventID: #{event_id}, Category: #{category}"
        logger.trace "Adding event to event list (#{log_attributes})"

        stream_name = event_list_stream_name entity_id, category

        event_added = Messages::Added.follow(
          publish_event_initiated,
          include: %i(entity_id event_id event_data_text)
        )

        event_added.time = clock.iso8601

        write.(event_added, stream_name)

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

      class QueryProjection
        include EntityProjection

        apply Messages::Added do |added|
          entity << added.event_id
        end
      end
    end
  end
end
