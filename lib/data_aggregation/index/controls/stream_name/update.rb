module DataAggregation::Index::Controls
  module StreamName
    module Update
      def self.example
        PublishEvent.example
      end

      module PublishEvent
        def self.example(i=nil, event_id: nil)
          event_id ||= ID::SourceEvent.example i
          category = Category.example

          StreamName.get event_id, category
        end
      end

      module StartReference
        def self.example(i=nil)
          related_entity_id = ID::RelatedEntity.example i
          category = Category.example

          StreamName.get related_entity_id, category
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
