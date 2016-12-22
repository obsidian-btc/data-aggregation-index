module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        include Log::Dependency
        include StreamName

        configure :copy

        attr_reader :update

        dependency :copy_message, DataAggregation::CopyMessage

        def initialize(update)
          @update = update
        end

        def self.build(update, session: nil)
          if update.is_a? Entity::PublishEvent
            subclass = Reference
          elsif update.is_a? Entity::AddReference
            subclass = PublishedEvent
          else
            error_message = "Unknown entity type #{update.class.name}; must be either PublishEvent or AddReference"
            logger = Log.get self
            logger.error error_message
            raise TypeError, error_message
          end

          instance = subclass.new update
          DataAggregation::CopyMessage.configure instance, session: session
          instance
        end

        abstract :call

        module Assertions
          def self.extended(copy)
            copy_message = copy.copy_message

            copy_message.extend copy_message.class::Assertions
          end

          def session?(session)
            copy_message.session? session
          end
        end

        module EventData
          module Transformer
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
