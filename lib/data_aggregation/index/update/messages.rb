module DataAggregation::Index
  module Update
    module Messages
      class PublishEventInitiated
        include EventStore::Messaging::Message

        attribute :entity_id, String
        attribute :event_id, String

        attribute :event_data_text, String
        attribute :event_list_position, Integer
        attribute :time, String
      end

      class AddReferenceInitiated
        include EventStore::Messaging::Message

        attribute :entity_id, String
        attribute :related_entity_id, String

        attribute :related_entity_category, String
        attribute :reference_list_position, Integer
        attribute :time, String
      end

      class Started
        include EventStore::Messaging::Message

        attribute :update_id, String

        attribute :event_list_position, Integer
        attribute :reference_list_position, Integer
        attribute :time, String

        def copy_position
          nil
        end
      end

      class BatchAssembled
        include EventStore::Messaging::Message

        attribute :update_id, String

        attribute :batch_position, Integer
        attribute :batch_data, Array, default: ->{ Array.new }
        attribute :time, String
      end

      class BatchCopied
        include EventStore::Messaging::Message

        attribute :update_id, String

        attribute :copy_position, Integer
        attribute :time, String
      end

      class Completed
        include EventStore::Messaging::Message

        attribute :update_id, String

        attribute :time, String
      end
    end
  end
end
