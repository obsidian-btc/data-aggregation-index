module DataAggregation::Index::Controls
  module EventList
    module Messages
      module Added
        def self.example(position=nil)
          position ||= Position::EventList.example

          message = DataAggregation::Index::EventList::Messages::Added.build
          message.entity_id = ID::Entity.example
          message.event_id = ID::SourceEvent.example position
          message.position = position
          message.event_data_text = SourceEvent::EventData::Text.example position
          message.time = Time.example
          message
        end
      end
    end
  end
end
