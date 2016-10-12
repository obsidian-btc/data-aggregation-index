module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        class References < Copy
          attr_reader :update
          attr_reader :destination_stream_names

          dependency :copy_message, EventStore::CopyMessage

          def initialize(update, destination_stream_names)
            @update = update
            @destination_stream_names = destination_stream_names
          end

          def configure
            EventStore::CopyMessage.configure self
          end

          def call
            destination_stream_names.each do |stream_name|
              copy_message.(event_data, stream_name)
            end
          end

          def event_data
            @event_data ||= Serialize::Read.(update.event_data_text, :json, EventData)
          end

          module EventData
            module Serializer
              def self.json
                JSON
              end

              def self.instance(raw_data)
                event_data = EventStore::Client::HTTP::EventData::Write.build
                event_data.id = raw_data[:event_id]
                event_data.type = raw_data[:event_type]
                event_data.data = raw_data[:data]
                event_data.metadata = raw_data[:metadata]
                event_data
              end

              module JSON
                def self.deserialize(text)
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
end
