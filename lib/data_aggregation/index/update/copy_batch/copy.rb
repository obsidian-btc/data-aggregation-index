module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        include Telemetry::Logger::Dependency
        include StreamName

        configure :copy

        attr_reader :update

        dependency :copy_message, EventStore::CopyMessage

        def initialize(update)
          @update = update
        end

        def self.build(update)
          if update.is_a? Entity::PublishEvent
            subclass = References
          elsif update.is_a? Entity::AddReference
            subclass = PublishedEvents
          else
            error_message = "Unknown entity type #{update.class.name}; must be either PublishEvent or AddReference"
            logger = Telemetry::Logger.get self
            logger.error error_message
            raise TypeError, error_message
          end

          instance = subclass.new update
          EventStore::CopyMessage.configure instance
          instance
        end

        abstract :call

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
