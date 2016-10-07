module DataAggregation::Index
  module Update
    class Store
      include EventStore::EntityStore

      entity Entity
      projection Projection

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
end
