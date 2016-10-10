module DataAggregation::Index::Controls
  module RecentListEntryQuery
    module ListEntry
      def self.example(i=nil)
        message = ExampleMessage.new
        message.list_entry_id = UpdateID.example i
        message
      end

      class ExampleMessage
        include EventStore::Messaging::Message

        attribute :list_entry_id, String
      end
    end
  end
end
