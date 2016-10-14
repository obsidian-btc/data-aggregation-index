module DataAggregation::Index::Controls
  module Update
    module Entity
      module Initiated
        def self.example
          entity = ExampleEntity.new
          entity.entity_id = ID::Entity.example
          entity.update_id = ID::Update.example
          entity
        end
      end

      module Started
        def self.example
          entity = Initiated.example
          entity.list_position = Position::FactList.example
          entity.record_started
          entity
        end
      end

      module Copying
        def self.example(batch_index=nil)
          batch_index ||= 0

          entity = Started.example
          entity.batch_position = Batch::Position::Stop.example batch_index

          if batch_index > 0
            entity.copy_position = Batch::Position::Stop.example batch_index - 1
          end

          entity
        end
      end

      module Assembling
        def self.example(batch_index=nil)
          batch_index ||= 1

          entity = Started.example
          entity.batch_position = Batch::Position::Stop.example batch_index - 1
          entity.copy_position = Batch::Position::Stop.example batch_index - 1
          entity
        end
      end

      module Finished
        def self.example
          entity = Started.example
          entity.batch_position = entity.list_position
          entity.copy_position = entity.list_position
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

      class ExampleEntity < DataAggregation::Index::Update::Entity
        attribute :update_id, String

        def record_started
          self.started = true
        end

        def type
          "ExampleEntity"
        end
      end
    end
  end
end
