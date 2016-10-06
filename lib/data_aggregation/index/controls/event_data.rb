module DataAggregation::Index::Controls
  module EventData
    module Read
      def self.example
        EventStore::Client::HTTP::Controls::EventData::Read.example
      end
    end

    module Write
      def self.example
        EventStore::Client::HTTP::Controls::EventData::Write.example
      end
    end

    module Text
      def self.example
        EventStore::Client::HTTP::Controls::EventData::Write::JSON.text
      end
    end
  end
end
