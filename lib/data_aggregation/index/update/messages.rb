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
        attribute :destination_stream_name, String
        attribute :reference_list_position, Integer
        attribute :time, String
      end

      class Started
        include EventStore::Messaging::Message

        attribute :update_id, String
        attribute :event_list_position, Integer
        attribute :reference_list_position, Integer
        attribute :time, String
      end
    end
  end
end
