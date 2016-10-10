module DataAggregation::Index::Controls
  module StreamName
    def self.get(stream_id, category)
      EventStore::Messaging::StreamName.stream_name stream_id, category
    end

    def self.example(random: nil)
      stream_id = ID.example
      category = Category.example 'someStream', random: random

      get stream_id, category
    end

    class Example
      include DataAggregation::Index::StreamName
    end
  end
end
