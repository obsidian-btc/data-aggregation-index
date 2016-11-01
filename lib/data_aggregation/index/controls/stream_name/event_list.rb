module DataAggregation::Index::Controls
  module StreamName
    module EventList
      def self.example
        stream_id = ID::Entity.example
        category = Category.example

        StreamName.get stream_id, category
      end

      module Category
        def self.example
          "#{StreamName::Category.example}Events"
        end

        module EventStore
          def self.example
            ::EventStore::Messaging::StreamName.category_stream_name Category.example
          end
        end
      end
    end
  end
end
