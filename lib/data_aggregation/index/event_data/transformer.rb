module DataAggregation::Index
  module EventData
    module Transformer
      def self.json
        JSON
      end

      def self.instance(raw_data)
        instance = EventStore::Client::HTTP::EventData::Write.build
        instance.id = raw_data[:event_id]
        instance.type = raw_data[:event_type]
        instance.data = raw_data[:data]
        instance.metadata = raw_data[:metadata]
        instance
      end

      module JSON
        def self.read(text)
          formatted_data = ::JSON.parse text, symbolize_names: true
          Casing::Underscore.(formatted_data)
        end
      end
    end
  end
end
