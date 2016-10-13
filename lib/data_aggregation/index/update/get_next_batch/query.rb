module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        include Telemetry::Logger::Dependency
        include StreamName

        configure :query

        attr_accessor :category

        abstract :call

        def self.build(update, category)
          if update.is_a? Entity::PublishEvent
            subclass = References
          elsif update.is_a? Entity::AddReference
            subclass = PublishedEvents
          else
            error_message = "Unknown update type #{update.class.name}; must be either PublishEvent or AddReference"
            logger = Telemetry::Logger.get self
            logger.error error_message
            raise TypeError, error_message
          end

          instance = subclass.new
          instance.category = category
          instance
        end
      end
    end
  end
end
