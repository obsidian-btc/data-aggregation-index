module DataAggregation::Index::Controls
  module StreamName
    module Index
      def self.example
        stream_id = ID::Entity.example
        category = Category.example

        StreamName.get stream_id, category
      end

      module Category
        def self.example
          StreamName::Category.example
        end
      end
    end
  end
end
