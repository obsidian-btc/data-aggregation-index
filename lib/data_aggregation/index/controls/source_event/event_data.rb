module DataAggregation::Index::Controls
  module SourceEvent
    module EventData
      module Read
        def self.example(i=nil)
          event_id = ID::Event.example i

          metadata = Metadata.example

          EventStore::Client::HTTP::Controls::EventData::Read.example(
            event_id,
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
            metadata: metadata,
            type: SomeEvent.message_type
          )
        end
      end

      module Batch
        def self.example
          batch_size = Position::Batch::Size.example

          (0..batch_size).map do |i|
            Write.example i
          end
        end
      end

      module Text
        def self.example(i=nil)
          event_data = Write.example i

          Serialize::Write.(event_data, :json)
        end

        module Batch
          def self.example
            event_data_list = EventData::Batch.example
            event_data_list.map do |event_data|
              Serialize::Write.(event_data, :json)
            end
          end
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
