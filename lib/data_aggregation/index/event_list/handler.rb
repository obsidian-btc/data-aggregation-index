module DataAggregation::Index
  module EventList
    class Handler
      include EventStore::Messaging::Handler

      dependency :session, EventSource::EventStore::HTTP::Session

      def configure
        EventSource::EventStore::HTTP::Session.configure self
      end

      handle Messages::Added do |added, event_data|
        UpdateIndex.(added, event_data, session: session)
      end
    end
  end
end
