module DataAggregation::Index
  module Messages
    class UpdateInitiated
      include EventStore::Messaging::Message

      attribute :entity_id, String
      attribute :update_id, String

      attribute :event_list_position, Integer
      attribute :reference_list_position, Integer

      attribute :time, String
    end

    class EventAdded
      include EventStore::Messaging::Message

      attribute :entity_id, String
      attribute :event_id, String

      attribute :event_data_text, String
      attribute :time, String
    end

    class ReferenceAdded
      include EventStore::Messaging::Message

      attribute :entity_id, String
      attribute :related_entity_id, String

      attribute :destination_stream_name, String
      attribute :time, String
    end
  end
end
