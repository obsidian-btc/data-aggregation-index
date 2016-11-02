module DataAggregation::Index::Controls
  module StreamName
    module Entity
      def self.example(stream_id: nil)
        stream_id ||= ID::Entity.example
        category = Category.example

        StreamName.get stream_id, category
      end

      module Category
        def self.example
          'someEntity'
        end
      end
    end
  end
end
