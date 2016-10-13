module DataAggregation::Index
  class Handler
    include EventStore::Messaging::Handler

    handle Messages::UpdateStarted do |update_started, event_data|
      Update::Start.(update_started, event_data)
    end
  end
end
