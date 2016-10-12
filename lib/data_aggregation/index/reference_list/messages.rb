module DataAggregation::Index
  module ReferenceList
    module Messages
      class Added
        include EventStore::Messaging::Message

        attribute :entity_id, String

        attribute :related_entity_id, String
        attribute :related_entity_category, String

        attribute :position, Integer
        attribute :time, String
      end
    end
  end
end
