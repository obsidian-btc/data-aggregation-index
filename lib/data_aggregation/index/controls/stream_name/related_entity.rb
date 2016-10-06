module DataAggregation::Index::Controls
  module StreamName
    module RelatedEntity
      def self.example(i=nil)
        stream_id = ID::RelatedEntity.example i
        category = Category.example

        StreamName.get stream_id, category
      end

      module Category
        def self.example
          "someRelatedEntity"
        end
      end
    end
  end
end
