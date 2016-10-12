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

        def related_entity_stream_name
          StreamName.stream_name related_entity_id, related_entity_category
        end
      end
    end
  end
end
