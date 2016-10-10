module DataAggregation::Index
  module ReferenceList
    class Handler
      include EventStore::Messaging::Handler

      handle Messages::ReferenceAdded do |reference_added, event_data|
        UpdateIndex.(reference_added, event_data)
      end
    end
  end
end
