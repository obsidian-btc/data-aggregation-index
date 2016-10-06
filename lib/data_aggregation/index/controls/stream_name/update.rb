module DataAggregation::Index::Controls
  module StreamName
    module Update
      def self.example
        Event.example
      end

      module Event
        def self.example(i=nil)
          stream_id = ID::Event.example i
          category = Category.example

          StreamName.get stream_id, category
        end
      end

      module Reference
        def self.example(i=nil)
          stream_id = ID::RelatedEntity.example i
          category = Category.example

          StreamName.get stream_id, category
        end
      end

      module Category
        def self.example
          "#{StreamName::Category.example}:update"
        end
      end
    end
  end
end
