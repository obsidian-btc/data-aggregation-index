module DataAggregation::Index::Controls
  module EventList
    module Write
      def self.call(ending_position=nil, category: nil)
        category ||= StreamName::Category.example random: true

        entity_id = ID::Entity.example
        stream_name = DataAggregation::Index::StreamName.event_list_stream_name entity_id, category

        message_control = Messages::Added

        DataAggregation::Index::Controls::Write.(message_control, ending_position, stream_name: stream_name)

        stream_name
      end
    end
  end
end
