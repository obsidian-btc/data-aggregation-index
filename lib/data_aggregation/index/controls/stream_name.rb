module DataAggregation::Index::Controls
  module StreamName
    def self.get(stream_id, category)
      EventStore::Messaging::StreamName.stream_name stream_id, category
    end

    class Example
      include DataAggregation::Index::StreamName
    end

    module Category
      def self.example
        'someIndex'
      end
    end
  end
end
