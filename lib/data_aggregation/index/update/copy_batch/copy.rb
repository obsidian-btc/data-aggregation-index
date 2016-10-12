module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        include Telemetry::Logger::Dependency
        include StreamName

        configure :copy

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
