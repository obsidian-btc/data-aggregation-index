module DataAggregation::Index::Controls
  module SourceEvent
    module EventData
      def self.data
        {
          :some_attribute => Attribute.data,
          :some_time => Time.example
        }
      end

      module Read
        def self.example(i=nil)
          event_id = ID::Event.example i

          metadata = Metadata.example

          EventStore::Client::HTTP::Controls::EventData::Read.example(
            event_id,
            data: EventData.data,
            metadata: metadata,
            type: SomeEvent.message_type
          )
        end
      end

      module Write
        def self.example(i=nil)
          event_id = ID::SourceEvent.example i

          metadata = Metadata.example

          EventStore::Client::HTTP::Controls::EventData::Write.example(
            event_id,
            data: EventData.data,
            metadata: metadata,
            type: SomeEvent.message_type
          )
        end
      end

      module Text
        def self.example(i=nil)
          event_data = Write.example i

          Transform::Write.(event_data, :json)
        end
      end

      module Metadata
        def self.example
          metadata = SourceEvent::Metadata.example
          metadata.to_h
        end
      end
    end
  end
end
