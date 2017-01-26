module DataAggregation::Index
  module Update
    class Store
      include EventStore::EntityStore

      entity Entity
      projection Projection

      def self.build(category=nil, session: nil)
        instance = super session: session

        if category
          category = StreamName.update_category category
          instance.category = category
        end

        instance
      end

      attr_writer :category

      def category
        category = @category

        if category.nil?
          error_message = "Category name not specified"
          logger.error error_message
          raise error_message
        end

        category
      end

      module Assertions
        def session?(session)
          self.session.equal? session
        end
      end
    end
  end
end
