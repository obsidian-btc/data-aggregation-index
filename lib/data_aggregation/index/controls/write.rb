module DataAggregation::Index::Controls
  module Write
    def self.call(message_control, ending_position=nil, stream_name: nil)
      ending_position ||= 0
      stream_name ||= StreamName::Index.example random: true

      messages = (0..ending_position).map do |i|
        message_control.example i
      end

      write = Messaging::EventStore::Write.build
      write.initial messages, stream_name

      stream_name
    end
  end
end
