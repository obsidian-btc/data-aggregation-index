module DataAggregation::Index
  module Update
    module Messages
      class PublishEventInitiated
        include EventStore::Messaging::Message

        attribute :event_id, String
        attribute :event_data_text, String
        attribute :time, String
      end

      class StartReferenceInitiated
        include EventStore::Messaging::Message

        attribute :related_entity_id, String
        attribute :destination_stream_name, String
        attribute :time, String
      end

      class Started
        include EventStore::Messaging::Message

        attribute :update_id, String
        attribute :event_stream_position, Integer
        attribute :reference_stream_position, Integer
        attribute :time, String
      end
    end
  end
end
