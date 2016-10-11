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

      module Copying
        def self.example(batch_index=nil)
          PublishEvent::Copying.example batch_index
        end
      end

      module Finished
        def self.example
          entity = Started.example
          entity.copy_position = entity.data_stream_position
          entity
        end
      end

      module Completed
        def self.example
          entity = Finished.example
          entity.record_completed
          entity
        end
      end

      module Assembling
        def self.example(batch_index=nil)
          batch_index ||= 1

          entity = Started.example
          entity.batch_position = Position::Batch::Stop.example batch_index - 1
          entity.copy_position = Position::Batch::Stop.example batch_index - 1
          entity
        end
      end

      module PublishEvent
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
            entity.reference_list_position = Position::ReferenceList.example
            entity.started = true
            entity
          end
        end

        module Copying
          def self.example(batch_index=nil)
            batch_index ||= 0

            entity = Started.example
            entity.batch_position = Position::Batch::Stop.example batch_index
            entity.copy_position = Position::Batch::Start.example batch_index
            entity
          end
        end
      end

      module AddReference
        module Initiated
          def self.example(i=nil)
            entity = DataAggregation::Index::Update::Entity.new
            entity.extend DataAggregation::Index::Update::Entity::AddReference
            entity.entity_id = ID::Entity.example
            entity.related_entity_id = ID::RelatedEntity.example i
            entity.destination_stream_name = StreamName::RelatedEntity.example i
            entity
          end
        end

        module Started
          def self.example(i=nil)
            entity = Initiated.example
            entity.event_list_position = Position::EventList.example
            entity.started = true
            entity
          end
        end
      end
    end
  end
end
