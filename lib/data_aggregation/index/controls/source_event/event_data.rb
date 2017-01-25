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

          EventSource::Controls::EventData::Read.example(
            id: event_id,
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

          EventSource::Controls::EventData::Write.example(
            id: event_id,
            data: EventData.data,
            metadata: metadata,
            type: SomeEvent.message_type
          )
        end
      end

      module Text
        def self.example(i=nil)
          event_data = Write.example i

          data = Casing::Camel.(event_data.data)
          metadata = Casing::Camel.(event_data.metadata)

          JSON.pretty_generate({
            'eventId' => event_data.id,
            'eventType' => event_data.type,
            'data' => data,
            'metadata' => metadata
          })
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
