module DataAggregation::Index::Controls
  module Update
    module Messages
      module Initiated
        module PublishEvent
          def self.example(i=nil)
            event_data_text = EventData::Text.example

            message = DataAggregation::Index::Update::Messages::Initiated.new
            message.update_id = ID::Event.example i
            message.update_data = event_data_text
            message
          end
        end

        module StartReference
          def self.example(i=nil)
            destination_stream_name = StreamName::RelatedEntity.example

            message = DataAggregation::Index::Update::Messages::Initiated.new
            message.update_id = ID::RelatedEntity.example i
            message.update_data = destination_stream_name
            message
          end
        end
      end

      module Started
        module PublishEvent
          def self.example(i=nil, reference_stream_position: nil)
            reference_stream_position ||= Position::ReferenceList.example

            event_data_text = EventData::Text.example

            message = DataAggregation::Index::Update::Messages::Started.new
            message.update_id = ID::Event.example i
            message.data_stream_position = reference_stream_position
            message
          end
        end

        module StartReference
          def self.example(i=nil, event_stream_position: nil)
            event_stream_position ||= Position::EventList.example

            message = DataAggregation::Index::Update::Messages::Started.new
            message.update_id = ID::RelatedEntity.example i
            message.data_stream_position = event_stream_position
            message
          end
        end
      end
    end
  end
end
