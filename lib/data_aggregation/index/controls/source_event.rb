module DataAggregation::Index::Controls
  module SourceEvent
    def self.example(entity_id: nil)
      event = SomeEvent.build
      event.some_attribute = Attribute.some_attribute
      event.some_time = Attribute.some_time
      event.metadata = Metadata.example entity_id: entity_id
      event
    end

    class SomeEvent
      include EventStore::Messaging::Message

      attribute :some_attribute, String
      attribute :some_time, String
    end
  end
end
