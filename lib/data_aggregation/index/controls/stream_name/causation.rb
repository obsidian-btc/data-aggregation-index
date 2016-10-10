module DataAggregation::Index::Controls
  module StreamName
    module Causation
      def self.example
        stream_id = ID.example
        category = Category.example

        StreamName.get stream_id, category
      end

      module Category
        def self.example
          'someCausationStream'
        end
      end
    end
  end
end
