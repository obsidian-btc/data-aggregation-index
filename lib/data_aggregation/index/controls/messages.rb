module DataAggregation::Index::Controls
  module Messages
    def self.example
      UpdateStarted.example
    end

    module UpdateStarted
      def self.example(i=nil, update_id: nil, event_list_position: nil, reference_list_position: nil)
        update_id ||= ID::Update.example i
        event_list_position = true if event_list_position == nil
        reference_list_position = true if reference_list_position == nil

        event_list_position = Position::EventList.example if event_list_position == true
        reference_list_position = Position::ReferenceList.example if reference_list_position == true

        message = DataAggregation::Index::Messages::UpdateStarted.build
        message.entity_id = ID::Entity.example
        message.update_id = update_id
        message.event_list_position = event_list_position if event_list_position
        message.reference_list_position = reference_list_position if reference_list_position
        message.time = Time.example
        message.metadata.source_event_stream_name = StreamName::Index.example
        message.metadata.source_event_position = 0
        message
      end

      module PublishEvent
        def self.example(i=nil, reference_list_position: nil)
          i ||= 0
          update_id ||= ID::SourceEvent.example i
          reference_list_position ||= false

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
          event_list_position ||= false

          message = UpdateStarted.example(
            update_id: update_id,
            event_list_position: event_list_position
          )
          message.reference_list_position = i
          message
        end
      end
    end
  end
end
