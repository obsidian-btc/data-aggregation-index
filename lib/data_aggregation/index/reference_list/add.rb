module DataAggregation::Index
  module ReferenceList
    class Add
      include StreamName
      include Log::Dependency

      attr_reader :add_reference_initiated_event
      attr_reader :category

      dependency :clock, Clock::UTC
      dependency :write, Messaging::EventStore::Write

      def initialize(add_reference_initiated_event, category)
        @add_reference_initiated_event = add_reference_initiated_event
        @category = category
      end

      def self.build(add_reference_initiated_event, session: nil)
        update_stream_name = add_reference_initiated_event.metadata.stream_name
        category = StreamName.get_category update_stream_name

        instance = new add_reference_initiated_event, category
        Clock::UTC.configure instance
        Messaging::EventStore::Write.configure instance, session: session
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        log_attributes = "EntityID: #{entity_id}, RelatedEntityID: #{related_entity_id}, Category: #{category}"
        logger.trace "Adding reference to reference list (#{log_attributes})"

        stream_name = reference_list_stream_name entity_id, category

        reference_added = Messages::Added.follow(
          add_reference_initiated_event,
          include: %i(entity_id related_entity_id related_entity_category)
        )

        reference_added.time = clock.iso8601

        write.(reference_added, stream_name)

        logger.debug "Reference added to reference list (#{log_attributes})"

        reference_added
      end

      def entity_id
        add_reference_initiated_event.entity_id
      end

      def related_entity_id
        add_reference_initiated_event.related_entity_id
      end

      class QueryProjection
        include EntityProjection

        apply Messages::Added do |added|
          entity << added.related_entity_id
        end
      end
    end
  end
end
