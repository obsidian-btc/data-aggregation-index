module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        include Log::Dependency
        include StreamName

        configure :query

        attr_accessor :category

        dependency :session, EventSource::EventStore::HTTP::Session

        abstract :call

        def self.build(update, category, session: nil)
          if update.is_a? Entity::PublishEvent
            subclass = References
          elsif update.is_a? Entity::AddReference
            subclass = PublishedEvents
          else
            error_message = "Unknown update type #{update.class.name}; must be either PublishEvent or AddReference"
            logger = Log.get self
            logger.error error_message
            raise TypeError, error_message
          end

          instance = subclass.new
          instance.category = category
          EventSource::EventStore::HTTP::Session.configure instance, session: session
          instance
        end

        module Assertions
          def session?(session)
            self.session.equal? session
          end
        end
      end
    end
  end
end
