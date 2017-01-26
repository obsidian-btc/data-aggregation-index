module DataAggregation::Index
  module ReferenceList
    class Handler
      include EventStore::Messaging::Handler

      dependency :session, EventSource::EventStore::HTTP::Session

      def configure
        EventSource::EventStore::HTTP::Session.configure self
      end

      handle Messages::Added do |added|
        UpdateIndex.(added, session: session)
      end
    end
  end
end
