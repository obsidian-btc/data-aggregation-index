module DataAggregation::Index::Controls
  module StreamName
    def self.get(stream_id, category)
      Messaging::StreamName.stream_name stream_id, category
    end

    class Example
      include DataAggregation::Index::StreamName
    end
  end
end
