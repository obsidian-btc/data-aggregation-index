module DataAggregation::Index::Controls
  module Messages
    module UpdateStarted
      def self.example(update_id: nil, event_list_position: nil, reference_list_position: nil)
        update_id ||= ID::Update.example

        message = DataAggregation::Index::Messages::UpdateStarted.build
        message.entity_id = ID::Entity.example
        message.update_id = update_id
        message.event_list_position = event_list_position if event_list_position
        message.reference_list_position = reference_list_position if reference_list_position
        message.time = Time.example
        message
      end

      module PublishEvent
        def self.example(i=nil, reference_list_position: nil)
          i ||= 0
          update_id ||= ID::SourceEvent.example i

          message = UpdateStarted.example(
            update_id: update_id,
            reference_list_position: reference_list_position
          )
          message.event_list_position = i
          message
        end
      end

      module AddReference
        def self.example(i=nil, event_list_position: nil)
          i ||= 0
          update_id = ID::RelatedEntity.example i

          message = UpdateStarted.example(
            update_id: update_id,
            event_list_position: event_list_position
          )
          message.reference_list_position = i
          message
        end
      end
    end

    module EventAdded
      def self.example(i=nil)
        message = DataAggregation::Index::Messages::EventAdded.build
        message.entity_id = ID::Entity.example
        message.event_id = ID::SourceEvent.example i
        message.event_data_text = SourceEvent::EventData::Text.example
        message.time = Time.example
        message
      end
    end

    module ReferenceAdded
      def self.example(i=nil)
        message = DataAggregation::Index::Messages::ReferenceAdded.build
        message.entity_id = ID::Entity.example
        message.related_entity_id = ID::RelatedEntity.example i
        message.destination_stream_name = StreamName::RelatedEntity.example i
        message.time = Time.example
        message
      end
    end
  end
end
