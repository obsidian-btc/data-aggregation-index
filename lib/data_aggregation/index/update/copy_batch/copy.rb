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
      end
    end
  end
end
