module DataAggregation::Index
  module Update
    module Messages
      class Initiated
        include EventStore::Messaging::Message

        attribute :update_id, String
        attribute :update_data, String
        attribute :time, String
      end

      class Started
        include EventStore::Messaging::Message

        attribute :update_id, String
        attribute :data_stream_position, Integer
        attribute :time, String
      end
    end
  end
end
