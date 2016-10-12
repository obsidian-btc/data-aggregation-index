module DataAggregation::Index::Controls
  module Update
    module Entity
      module PublishEvent
        def self.example
          Started.example
        end

        module Initiated
          def self.example(i=nil)
            entity = DataAggregation::Index::Update::Entity.new
            entity.extend DataAggregation::Index::Update::Entity::PublishEvent
            entity.entity_id = ID::Entity.example
            entity.event_id = ID::SourceEvent.example i
            entity.event_data_text = SourceEvent::EventData::Text.example
            entity
          end
        end

        module Started
          def self.example(i=nil)
            entity = Initiated.example
            entity.list_position = Position::ReferenceList.example
            entity.started = true
            entity
          end
        end
      end
    end
  end
end
