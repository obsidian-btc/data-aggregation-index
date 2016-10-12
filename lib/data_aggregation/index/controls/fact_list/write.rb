module DataAggregation::Index::Controls
  module FactList
    module Write
      def self.call(ending_position=nil, stream_name: nil)
        stream_name ||= StreamName::FactList.example random: true
        message_control = Entry

        DataAggregation::Index::Controls::Write.(
          message_control,
          ending_position,
          stream_name: stream_name
        )
      end
    end
  end
end
