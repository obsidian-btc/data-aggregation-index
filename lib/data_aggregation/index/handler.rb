module DataAggregation::Index
  class Handler
    include EventStore::Messaging::Handler

    dependency :session, EventStore::Client::HTTP::Session

    def configure
      EventStore::Client::HTTP::Session.configure self
    end

    handle Messages::UpdateStarted do |update_started, event_data|
      Update::Start.(update_started, event_data, session: session)
    end
  end
end
