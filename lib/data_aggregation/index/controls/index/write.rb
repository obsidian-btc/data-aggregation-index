module DataAggregation::Index::Controls
  module Index
    module Write
      def self.call(ending_position=nil, event_list_position: nil, reference_list_position: nil, category: nil)
        ending_position ||= Position::Index.example
        category ||= StreamName::Category.example random: true

        update_started = Messages::UpdateStarted.example(
          event_list_position: event_list_position,
          reference_list_position: reference_list_position
        )

        batch = [update_started] * ending_position.next

        entity_id = ID::Entity.example

        stream_name = DataAggregation::Index::StreamName.index_stream_name entity_id, category

        write = Messaging::EventStore::Write.build
        write.initial batch, stream_name

        stream_name
      end
    end
  end
end
