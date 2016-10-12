module DataAggregation::Index::Controls
  module StreamName
    module FactList
      def self.example(i=nil, random: nil)
        stream_id = ID::Update.example i
        category = Category.example random: random

        StreamName.get stream_id, category
      end

      module Category
        def self.example(random: nil)
          StreamName::Category.example 'someFactList', random: random
        end
      end
    end
  end
end

