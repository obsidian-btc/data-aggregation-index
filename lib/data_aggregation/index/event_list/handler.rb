module DataAggregation::Index
  module EventList
    class Handler
      include EventStore::Messaging::Handler

      handle Messages::EventAdded do |event_added, event_data|
        UpdateIndex.(event_added, event_data)
      end
    end
  end
end
