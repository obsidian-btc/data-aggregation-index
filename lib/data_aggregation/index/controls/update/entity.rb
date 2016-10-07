module DataAggregation::Index::Controls
  module Update
    module Entity
      module PublishEvent
        module Initiated
          def self.example(i=nil)
            entity = DataAggregation::Index::Update::Entity.new
            entity.extend DataAggregation::Index::Update::Entity::PublishEvent
            entity.event_id = ID::Event.example i
            entity.event_data_text = EventData::Text.example
            entity
          end
        end
      end

      module StartReference
        module Initiated
          def self.example(i=nil)
            entity = DataAggregation::Index::Update::Entity.new
            entity.extend DataAggregation::Index::Update::Entity::StartReference
            entity.related_entity_id = ID::RelatedEntity.example i
            entity.destination_stream_name = StreamName::RelatedEntity.example i
            entity
          end
        end
      end
    end
  end
end
