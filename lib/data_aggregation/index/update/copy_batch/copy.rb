module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        include Telemetry::Logger::Dependency
        include StreamName

        configure :copy

        attr_reader :batch_data
        attr_reader :update

        def initialize(update, batch_data)
          @update = update
          @batch_data = batch_data
        end

        def self.build(update, batch_data)
          if update.instance_of? Entity::PublishEvent
            subclass = References
          elsif update.instance_of? Entity::AddReference
            subclass = PublishedEvents
          else
            raise TypeError
          end

          instance = subclass.new update, batch_data
          instance.configure
          instance
        end

        abstract :call
        virtual :configure
      end
    end
  end
end
