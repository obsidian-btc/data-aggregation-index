module DataAggregation::Index
  module Update
    class GetNextBatch
      dependency :query, Query
      dependency :store, Store
      dependency :writer, EventStore::Messaging::Writer
    end
  end
end
