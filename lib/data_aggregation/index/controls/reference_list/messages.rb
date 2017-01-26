module DataAggregation::Index::Controls
  module ReferenceList
    module Messages
      def self.example
        Added.example
      end

      module Added
        def self.example(position=nil)
          position ||= Position::ReferenceList.example

          message = DataAggregation::Index::ReferenceList::Messages::Added.build
          message.entity_id = ID::Entity.example

          message.related_entity_id = ID::RelatedEntity.example position
          message.related_entity_category = StreamName::RelatedEntity::Category.example

          message.time = Time.example

          message.metadata.source_event_stream_name = StreamName::ReferenceList.example
          message.metadata.source_event_position = position
          message
        end
      end
    end
  end
end
