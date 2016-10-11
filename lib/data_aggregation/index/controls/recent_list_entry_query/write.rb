module DataAggregation::Index::Controls
  module RecentListEntryQuery
    module Write
      def self.call(ending_position=nil, stream_name: nil)
        message_control = ListEntry

        DataAggregation::Index::Controls::Write.(
          message_control,
          ending_position,
          stream_name: stream_name
        )
      end
    end
  end
end
