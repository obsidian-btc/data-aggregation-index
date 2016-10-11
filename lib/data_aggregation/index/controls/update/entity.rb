module DataAggregation::Index::Controls
  module Update
    module Entity
      module Initiated
        def self.example
          PublishEvent::Initiated.example
        end
      end

      module Started
        def self.example
          PublishEvent::Started.example
        end
      end

      module PublishEvent
        module Initiated
          def self.example(i=nil)
            entity = DataAggregation::Index::Update::Entity.new
            entity.extend DataAggregation::Index::Update::Entity::PublishEvent
            entity.event_id = ID::SourceEvent.example i
            entity.event_data_text = SourceEvent::EventData::Text.example
            entity
          end
        end

        module Started
          def self.example(i=nil)
            entity = Initiated.example
            entity.reference_list_position = Position::ReferenceList.example
            entity
          end
        end
      end

      module AddReference
        module Initiated
          def self.example(i=nil)
            entity = DataAggregation::Index::Update::Entity.new
            entity.extend DataAggregation::Index::Update::Entity::AddReference
            entity.related_entity_id = ID::RelatedEntity.example i
            entity.destination_stream_name = StreamName::RelatedEntity.example i
            entity
          end
        end

        module Started
          def self.example(i=nil)
            entity = Initiated.example
            entity.event_list_position = Position::EventList.example
            entity
          end
        end
      end
    end
  end
end
