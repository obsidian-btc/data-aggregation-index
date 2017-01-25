module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        module EventData
          module Transformer
            def self.json
              JSON
            end

            def self.instance(raw_data)
              event_data = EventSource::EventData::Write.build
              event_data.id = raw_data[:event_id]
              event_data.type = raw_data[:event_type]
              event_data.data = raw_data[:data]
              event_data.metadata = raw_data[:metadata]
              event_data
            end

            module JSON
              def self.read(text)
                formatted_data = ::JSON.parse text, symbolize_names: true
                raw_data = Casing::Underscore.(formatted_data)
                raw_data
              end
            end
          end
        end
      end
    end
  end
end
