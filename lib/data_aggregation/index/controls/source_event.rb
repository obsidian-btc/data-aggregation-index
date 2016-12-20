module DataAggregation::Index::Controls
  module SourceEvent
    def self.example(entity_id: nil, metadata: nil)
      event = SomeEvent.build
      event.some_attribute = Attribute.data
      event.some_time = Time.example

      unless metadata == false
        event.metadata = Metadata.example entity_id: entity_id
      end

      event
    end

    class SomeEvent
      include EventStore::Messaging::Message

      attribute :some_attribute, String
      attribute :some_time, String
    end
  end
end
