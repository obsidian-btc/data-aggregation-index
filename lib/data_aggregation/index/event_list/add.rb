module DataAggregation::Index
  module EventList
    class Add
      include StreamName
      include Telemetry::Logger::Dependency

      attr_reader :entity_id
      attr_reader :event_id
      attr_reader :event_data_text
      attr_reader :starting_position

      dependency :recent_event_added_query, RecentListEntryQuery

      def initialize(entity_id, event_id, event_data_text, starting_position)
        @entity_id = entity_id
        @event_id = event_id
        @event_data_text = event_data_text
        @starting_position = starting_position
      end

      def self.build(publish_event_initiated)
        instance = new(
          publish_event_initiated.entity_id,
          publish_event_initiated.event_id,
          publish_event_initiated.event_data_text,
          publish_event_initiated.starting_position
        )

        RecentListEntryQuery.configure instance, QueryProjection

        instance
      end

      class QueryProjection
        include EventStore::EntityProjection

        apply Messages::EventAdded do |event_added|
          entity << event_added.event_id
        end
      end
    end
  end
end
