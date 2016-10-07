module DataAggregation::Index::Controls
  module Event
    def self.example
      EventStore::Messaging::Controls::Message.example
    end

    SomeMessage = EventStore::Messaging::Controls::Message::SomeMessage
    Example = SomeMessage
  end
end
