module DataAggregation::Index
  module Update
    module Store
      def self.included(cls)
        cls.class_exec do
          include EventStore::EntityStore

          def category_name
            category_name = @category_name

            if category_name.nil?
              error_message = "Category name not specified"
              logger.error error_message
              raise error_message
            end

            category_name
          end
        end
      end

      class PublishEvent
        include Store

        entity Entity::PublishEvent
        projection Projection::PublishEvent
      end

      class StartReference
        include Store

        entity Entity::PublishEvent
        projection Projection::StartReference
      end
    end
  end
end
