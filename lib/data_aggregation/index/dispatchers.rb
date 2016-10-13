module DataAggregation::Index
  module Dispatchers
    class Index
      include EventStore::Messaging::Dispatcher
      handler Handler
    end

    class EventList
      include EventStore::Messaging::Dispatcher
      handler DataAggregation::Index::EventList::Handler
    end

    class ReferenceList
      include EventStore::Messaging::Dispatcher
      handler DataAggregation::Index::ReferenceList::Handler
    end

    class Update
      include EventStore::Messaging::Dispatcher
      handler DataAggregation::Index::Update::Handler
    end
  end
end
