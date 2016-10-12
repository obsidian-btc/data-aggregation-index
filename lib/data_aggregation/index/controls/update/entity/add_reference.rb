module DataAggregation::Index::Controls
  module Update
    module Entity
      module AddReference
        def self.example
          Started.example
        end

        module Initiated
          def self.example(i=nil)
            entity = DataAggregation::Index::Update::Entity.new
            entity.extend DataAggregation::Index::Update::Entity::AddReference
            entity.entity_id = ID::Entity.example
            entity.related_entity_id = ID::RelatedEntity.example i
            entity.related_entity_category = StreamName::RelatedEntity::Category.example
            entity
          end
        end

        module Started
          def self.example(i=nil)
            entity = Initiated.example
            entity.list_position = Position::EventList.example
            entity.started = true
            entity
          end
        end
      end
    end
  end
end
