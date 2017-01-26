module DataAggregation::Index::Controls
  module FactList
    class Entry
      def self.example(i=nil)
        message = ExampleMessage.new
        message.update_id = ID::Update.example i
        message
      end

      class ExampleMessage
        include Messaging::Message

        attribute :update_id, String
      end
    end
  end
end
