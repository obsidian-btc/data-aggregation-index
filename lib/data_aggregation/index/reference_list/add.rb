module DataAggregation::Index
  module ReferenceList
    class Add
      include StreamName
      include Telemetry::Logger::Dependency

      attr_reader :add_reference_initiated_event
      attr_reader :category

      dependency :clock, Clock::UTC
      dependency :recent_reference_added_query, RecentListEntryQuery
      dependency :writer, EventStore::Messaging::Writer

      def initialize(add_reference_initiated_event, category)
        @add_reference_initiated_event = add_reference_initiated_event
        @category = category
      end

      def self.build(add_reference_initiated_event, event_data)
        update_stream_name = event_data.stream_name
        category = StreamName.get_category update_stream_name

        instance = new add_reference_initiated_event, category
        Clock::UTC.configure instance
        RecentListEntryQuery.configure instance, QueryProjection, attr_name: :recent_reference_added_query
        EventStore::Messaging::Writer.configure instance
        instance
      end

      def call
        log_attributes = "EntityID: #{entity_id}, RelatedEntityID: #{related_entity_id}, StartingPosition: #{starting_position}, Category: #{category}"
        logger.trace "Adding reference to reference list (#{log_attributes})"

        stream_name = reference_list_stream_name entity_id, category

        version = recent_reference_added_query.(stream_name, related_entity_id, starting_position) do
          logger.debug "Reference already added to reference list; skipped (#{log_attributes})"
          return
        end

        reference_added = Messages::Added.proceed(
          add_reference_initiated_event,
          include: %i(entity_id related_entity_id)
        )
        # XXX
        reference_added.related_entity_category = EventStore::Messaging::StreamName.get_category(add_reference_initiated_event.destination_stream_name)
        # /XXX
        reference_added.position = version
        reference_added.time = clock.iso8601

        writer.write reference_added, stream_name, expected_version: version

        logger.debug "Reference added to reference list (#{log_attributes})"

        reference_added
      end

      def entity_id
        add_reference_initiated_event.entity_id
      end

      def related_entity_id
        add_reference_initiated_event.related_entity_id
      end

      def starting_position
        add_reference_initiated_event.reference_list_position
      end

      class QueryProjection
        include EventStore::EntityProjection

        apply Messages::Added do |added|
          entity << added.related_entity_id
        end
      end
    end
  end
end
