module DataAggregation::Index
  module EventList
    class Handler
      include EventStore::Messaging::Handler

      handle Messages::Added do |added, event_data|
        UpdateIndex.(added, event_data)
      end
    end
  end
end
