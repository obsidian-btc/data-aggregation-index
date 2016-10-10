module DataAggregation::Index::Controls
  module StreamName
    module Reply
      def self.example
        stream_id = ID.example
        category = Category.example

        StreamName.get stream_id, category
      end

      module Category
        def self.example
          'someReplyStream'
        end
      end
    end
  end
end
