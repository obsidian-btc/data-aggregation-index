module DataAggregation::Index
  class Handler
    include Messaging::Handle

    dependency :session, EventSource::EventStore::HTTP::Session

    def configure
      EventSource::EventStore::HTTP::Session.configure self
    end

    handle Messages::UpdateStarted do |update_started|
      Update::Start.(update_started, session: session)
    end
  end
end
