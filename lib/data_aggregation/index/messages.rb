module DataAggregation::Index
  module Messages
    class UpdateStarted
      include EventStore::Messaging::Message

      attribute :entity_id, String
      attribute :update_id, String

      attribute :event_list_position, Integer
      attribute :reference_list_position, Integer

      attribute :time, String
    end
  end
end
