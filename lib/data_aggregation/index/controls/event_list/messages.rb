module DataAggregation::Index::Controls
  module EventList
    module Messages
      def self.example
        Added.example
      end

      module Added
        def self.example(position=nil)
          position ||= Position::EventList.example

          message = DataAggregation::Index::EventList::Messages::Added.build
          message.entity_id = ID::Entity.example
          message.event_id = ID::SourceEvent.example position
          message.event_data_text = SourceEvent::EventData::Text.example position
          message.time = Time.example
          message.metadata.source_event_stream_name = StreamName::EventList.example
          message.metadata.source_event_position = Position::EventList.example
          message
        end
      end
    end
  end
end
