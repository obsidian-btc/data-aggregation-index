module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        include Telemetry::Logger::Dependency
        include StreamName

        configure :query

        attr_accessor :category

        abstract :call

        def self.build(entity)
          if entity.is_a? Entity::PublishEvent
            subclass = References
          elsif entity.is_a? Entity::AddReference
            subclass = PublishedEvents
          else
            error_message = "Unknown entity type #{entity.class.name}; must be either PublishEvent or AddReference"
            logger = Telemetry::Logger.get self
            logger.error error_message
            raise TypeError, error_message
          end

          subclass.new
        end
      end
    end
  end
end
