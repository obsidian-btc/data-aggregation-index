module DataAggregation::Index::Controls
  module StreamName
    module Correlation
      def self.example
        stream_id = ID.example
        category = Category.example

        StreamName.get stream_id, category
      end

      module Category
        def self.example
          'someCorrelationStream'
        end
      end
    end
  end
end
