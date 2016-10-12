module DataAggregation::Index
  module EventList
    module Messages
      class Added
        include EventStore::Messaging::Message

        attribute :entity_id, String
        attribute :event_id, String

        attribute :event_data_text, String
        attribute :position, Integer
        attribute :time, String
      end
    end
  end
end
