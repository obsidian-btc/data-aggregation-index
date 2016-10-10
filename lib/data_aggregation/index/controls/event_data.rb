module DataAggregation::Index::Controls
  module EventData
    module Read
      def self.example(i=nil, event_id: nil)
        event_id ||= ID::Event.example i

        metadata = Metadata.data

        EventStore::Client::HTTP::Controls::EventData::Read.example(
          event_id,
          metadata: metadata
        )
      end
    end

    module Write
      def self.example(i=nil, event_id: nil)
        event_id ||= ID::Event.example i

        metadata = Metadata.data

        EventStore::Client::HTTP::Controls::EventData::Write.example(
          event_id,
          metadata: metadata
        )
      end
    end

    module Metadata
      def self.data
        Event::Metadata.data
      end
    end

    module Text
      def self.example(event_id: nil)
        event_data = Write.example event_id: event_id

        Serialize::Write.(event_data, :json)
      end
    end
  end
end
