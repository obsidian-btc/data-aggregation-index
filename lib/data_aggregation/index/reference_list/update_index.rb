module DataAggregation::Index
  module ReferenceList
    class UpdateIndex
      include StreamName
      include Log::Dependency

      attr_reader :reference_added
      attr_reader :category
      attr_reader :reference_list_position

      dependency :clock, Clock::UTC
      dependency :get_positions, Queries::GetPositions
      dependency :write, Messaging::EventStore::Write

      def initialize(reference_added, category, reference_list_position)
        @reference_added = reference_added
        @category = category
        @reference_list_position = reference_list_position
      end

      def self.build(reference_added, event_data=nil, session: nil)
        reference_list_position = reference_added.metadata.source_event_position
        update_stream_name = reference_added.metadata.stream_name

        category = StreamName.get_category update_stream_name

        instance = new reference_added, category, reference_list_position
        Clock::UTC.configure instance
        Queries::GetPositions.configure instance, session: session
        Messaging::EventStore::Write.configure instance, session: session
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        log_attributes = "EntityID: #{entity_id}, Category: #{category}, RelatedEntityID: #{related_entity_id}, ReferenceAddedPosition: #{reference_added.position}"
        logger.trace "Starting update for reference (#{log_attributes})"

        index_pos, event_list_pos, reference_list_pos = get_positions.(entity_id, category)

        if reference_list_pos == :no_stream
          next_reference_list_pos = 0
        else
          next_reference_list_pos = reference_list_pos + 1
        end

        if next_reference_list_pos > reference_list_position
          logger.debug "Update already started for reference; skipped (#{log_attributes}, NextReferenceListPosition: #{next_reference_list_pos})"
          return
        end

        update_started = DataAggregation::Index::Messages::UpdateStarted.follow reference_added, include: :entity_id 
        update_started.update_id = related_entity_id
        update_started.event_list_position = event_list_pos unless event_list_pos == :no_stream
        update_started.reference_list_position = next_reference_list_pos
        update_started.time = clock.iso8601

        stream_name = index_stream_name entity_id, category

        write.(update_started, stream_name, expected_version: index_pos)

        logger.debug "Update started for reference (#{log_attributes}, NextReferenceListPosition: #{next_reference_list_pos})"

        update_started
      end

      def entity_id
        reference_added.entity_id
      end

      def related_entity_id
        reference_added.related_entity_id
      end
    end
  end
end
