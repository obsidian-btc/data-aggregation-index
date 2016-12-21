module DataAggregation::Index::Controls
  module EventData
    def self.example(stream_name: nil, number: nil)
      number ||= 0
      stream_name ||= StreamName::Index.example

      message = Messages::UpdateStarted.example
      write_event_data = EventStore::Messaging::Message::Export::EventData.(message)

      event_data = EventStore::Client::HTTP::EventData::Read.build
      event_data.type = write_event_data.type
      event_data.data = write_event_data.data
      event_data.metadata = write_event_data.metadata
      event_data.stream_name = stream_name
      event_data.number = number
      event_data
    end

    module Index
      def self.example
        stream_name = StreamName::Index.example
        EventData.example stream_name: stream_name
      end
    end

    module EventList
      def self.example
        stream_name = StreamName::EventList.example
        position = Position::EventList.example

        EventData.example stream_name: stream_name, number: position
      end
    end

    module ReferenceList
      def self.example
        stream_name = StreamName::ReferenceList.example
        position = Position::ReferenceList.example

        EventData.example stream_name: stream_name, number: position
      end
    end

    module Update
      def self.example
        stream_name = StreamName::Update.example
        EventData.example stream_name: stream_name
      end
    end
  end
end
