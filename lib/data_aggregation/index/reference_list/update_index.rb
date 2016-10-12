module DataAggregation::Index
  module ReferenceList
    class UpdateIndex
      include StreamName
      include Telemetry::Logger::Dependency

      attr_reader :reference_added
      attr_reader :category

      dependency :clock, Clock::UTC
      dependency :get_positions, Queries::GetPositions
      dependency :writer, EventStore::Messaging::Writer

      def initialize(reference_added, category)
        @reference_added = reference_added
        @category = category
      end

      def self.build(reference_added, event_data)
        update_stream_name = event_data.stream_name
        category = StreamName.get_category update_stream_name

        instance = new reference_added, category
        Clock::UTC.configure instance
        GetPositions.configure instance
        EventStore::Messaging::Writer.configure instance
        instance
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

        if next_reference_list_pos > reference_added.position
          logger.debug "Update already started for reference; skipped (#{log_attributes}, NextReferenceListPosition: #{next_reference_list_pos})"
          return
        end

        update_started = DataAggregation::Index::Messages::UpdateStarted.proceed reference_added, include: :entity_id 
        update_started.update_id = related_entity_id
        update_started.event_list_position = event_list_pos unless event_list_pos == :no_stream
        update_started.reference_list_position = next_reference_list_pos
        update_started.time = clock.iso8601

        stream_name = index_stream_name entity_id, category

        writer.write update_started, stream_name, expected_version: index_pos

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
