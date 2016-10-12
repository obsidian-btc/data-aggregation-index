module DataAggregation::Index::Controls
  module StreamName
    module Index
      def self.example(random: nil)
        stream_id = ID::Entity.example
        category = Category.example random: random

        StreamName.get stream_id, category
      end

      module Category
        def self.example(random: nil)
          StreamName::Category.example random: random
        end
      end
    end
  end
end
