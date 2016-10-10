module DataAggregation::Index::Controls
  module RecentListEntryQuery
    module Write
      def self.call(ending_position=nil, stream_name: nil)
        ending_position ||= 0
        stream_name ||= StreamName.example random: true

        list_entries = (0..ending_position).map do |i|
          ListEntry.example i
        end

        writer = EventStore::Messaging::Writer.build
        writer.write_initial list_entries, stream_name

        stream_name
      end
    end
  end
end
