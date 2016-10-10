module DataAggregation::Index::Controls
  module Update
    module Messages
      module PublishEventInitiated
        def self.example(i=nil)
          event_data_text = SourceEvent::EventData::Text.example i

          event = SourceEvent.example

          message = DataAggregation::Index::Update::Messages::PublishEventInitiated.proceed event, copy: false
          message.event_id = ID::SourceEvent.example i
          message.event_data_text = event_data_text
          #message.reference_stream_position = Position::ReferenceList::Initial.example
          message.time = Time.example
          message
        end
      end

      module AddReferenceInitiated
        def self.example(i=nil, event_stream_position: nil)
          unless event_stream_position == false
            event_stream_position ||= Position::EventList::Initial.example
          end

          destination_stream_name = StreamName::RelatedEntity.example

          message = DataAggregation::Index::Update::Messages::AddReferenceInitiated.new
          message.related_entity_id = ID::RelatedEntity.example i
          message.destination_stream_name = destination_stream_name
          message.event_stream_position = event_stream_position if event_stream_position
          message
        end
      end

      module Started
        def self.example(i=nil, event_stream_position: nil, reference_stream_position: nil)
          event_stream_position ||= Position::EventList::Update.example
          reference_stream_position ||= Position::ReferenceList::Update.example

          event_data_text = SourceEvent::EventData::Text.example

          message = DataAggregation::Index::Update::Messages::Started.new
          message.update_id = ID::SourceEvent.example i
          message.event_stream_position = event_stream_position
          message.reference_stream_position = reference_stream_position
          message
        end
      end
    end
  end
end
