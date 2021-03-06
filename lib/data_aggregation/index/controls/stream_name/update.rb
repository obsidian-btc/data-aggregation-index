module DataAggregation::Index::Controls
  module StreamName
    module Update
      def self.example(i=nil, random: nil)
        event_id = ID::Update.example i
        category = Category.example random: random

        StreamName.get event_id, category
      end

      module PublishEvent
        def self.example(i=nil, event_id: nil)
          event_id ||= ID::SourceEvent.example i
          category = Category.example

          StreamName.get event_id, category
        end
      end

      module AddReference
        def self.example(i=nil)
          related_entity_id = ID::RelatedEntity.example i
          category = Category.example

          StreamName.get related_entity_id, category
        end
      end

      module Category
        def self.example(random: nil)
          "#{StreamName::Category.example random: random}:update"
        end

        module EventStore
          def self.example
            "$ce-#{Category.example}"
          end
        end
      end
    end
  end
end
