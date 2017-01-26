module DataAggregation::Index
  module EventData
    module Transformer
      def self.json
        JSON
      end

      def self.instance(raw_data)
        instance = EventSource::EventData::Write.build
        instance.id = raw_data[:event_id]
        instance.type = raw_data[:event_type]
        instance.data = raw_data[:data]
        instance.metadata = raw_data[:metadata]
        instance
      end

      def self.raw_data(instance)
        {
          :event_id => instance.id,
          :event_type => instance.type,
          :data => instance.data,
          :metadata => instance.metadata
        }
      end

      module JSON
        def self.read(text)
          formatted_data = ::JSON.parse text, symbolize_names: true
          Casing::Underscore.(formatted_data)
        end

        def self.write(raw_data)
          formatted_data = Casing::Camel.(raw_data, symbol_to_string: true)
          ::JSON.pretty_generate formatted_data
        end
      end
    end
  end
end
