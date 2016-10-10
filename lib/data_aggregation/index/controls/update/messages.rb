module DataAggregation::Index::Controls
  module Update
    module Messages
      module PublishEventInitiated
        def self.example(i=nil, reference_list_position: nil)
          unless reference_list_position == false
            reference_list_position ||= Position::ReferenceList::Initial.example
          end

          event_data_text = SourceEvent::EventData::Text.example i

          event = SourceEvent.example

          message = DataAggregation::Index::Update::Messages::PublishEventInitiated.proceed event, copy: false
          message.event_id = ID::SourceEvent.example i
          message.event_data_text = event_data_text
          message.reference_stream_position = reference_list_position if reference_list_position
          message.time = Time.example
          message
        end
      end

      module AddReferenceInitiated
        def self.example(i=nil, event_list_position: nil)
          unless event_list_position == false
            event_list_position ||= Position::EventList::Initial.example
          end

          destination_stream_name = StreamName::RelatedEntity.example

          message = DataAggregation::Index::Update::Messages::AddReferenceInitiated.new
          message.related_entity_id = ID::RelatedEntity.example i
          message.destination_stream_name = destination_stream_name
          message.event_list_position = event_list_position if event_list_position
          message
        end
      end

      module Started
        def self.example(i=nil, event_list_position: nil, reference_stream_position: nil)
          event_list_position ||= Position::EventList::Update.example
          reference_stream_position ||= Position::ReferenceList::Update.example

          event_data_text = SourceEvent::EventData::Text.example

          message = DataAggregation::Index::Update::Messages::Started.new
          message.update_id = ID::SourceEvent.example i
          message.event_list_position = event_list_position
          message.reference_stream_position = reference_stream_position
          message
        end
      end
    end
  end
end
