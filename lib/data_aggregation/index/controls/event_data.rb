module DataAggregation::Index::Controls
  module EventData
    module Index
      def self.example
        message = Messages::UpdateStarted.example
        write_event_data = EventStore::Messaging::Message::Export::EventData.(message)

        event_data = EventStore::Client::HTTP::EventData::Read.build
        event_data.type = write_event_data.type
        event_data.data = write_event_data.data
        event_data.metadata = write_event_data.metadata
        event_data.stream_name = StreamName::Index.example
        event_data.number = Position::Index.example
        event_data.position = Position::Index.example
        event_data
      end
    end
  end
end
