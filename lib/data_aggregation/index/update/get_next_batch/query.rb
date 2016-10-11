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
          if entity.instance_of? Entity::PublishEvent
            subclass = References
          elsif entity.instance_of? Entity::AddReference
            subclass = PublishedEvents
          else
            raise TypeError
          end

          subclass.new
        end
      end
    end
  end
end
