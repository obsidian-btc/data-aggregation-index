module DataAggregation::Index::Controls
  module Update
    module Messages
      module PublishEventInitiated
        def self.example(i=nil, event_id: nil)
          event_id ||= ID::Event.example i

          event_data_text = EventData::Text.example event_id: event_id

          event = Event.example

          message = DataAggregation::Index::Update::Messages::PublishEventInitiated.proceed event, copy: false
          message.event_id = event_id
          message.event_data_text = event_data_text
          message.time = Time.example
          message
        end
      end

      module StartReferenceInitiated
        def self.example(i=nil)
          destination_stream_name = StreamName::RelatedEntity.example

          message = DataAggregation::Index::Update::Messages::StartReferenceInitiated.new
          message.related_entity_id = ID::RelatedEntity.example i
          message.destination_stream_name = destination_stream_name
          message
        end
      end

      module Started
        def self.example(i=nil, event_stream_position: nil, reference_stream_position: nil)
          event_stream_position ||= Position::EventList.example
          reference_stream_position ||= Position::ReferenceList.example

          event_data_text = EventData::Text.example

          message = DataAggregation::Index::Update::Messages::Started.new
          message.update_id = ID::Event.example i
          message.event_stream_position = event_stream_position
          message.reference_stream_position = reference_stream_position
          message
        end
      end
    end
  end
end
