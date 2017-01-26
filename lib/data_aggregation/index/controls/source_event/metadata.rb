module DataAggregation::Index::Controls
  module SourceEvent
    module Metadata
      def self.example(entity_id: nil)
        metadata = Messaging::Message::Metadata.build

        metadata.source_event_stream_name = StreamName::Entity.example stream_id: entity_id
        metadata.source_event_position = Position::EventList.example

        metadata.causation_event_stream_name = StreamName::Causation.example
        metadata.causation_event_position = 0

        metadata.correlation_stream_name = StreamName::Correlation.example
        metadata.reply_stream_name = StreamName::Reply.example
        metadata.schema_version = SchemaVersion.example
        metadata
      end

      module CausationEventURI
        def self.example
          stream_name = StreamName::Causation.example

          "streams/#{stream_name}/0"
        end
      end

      module SourceEventURI
        def self.example(i=nil, entity_id: nil)
          i ||= Position::EventList.example

          stream_name = StreamName::Entity.example stream_id: entity_id

          "streams/#{stream_name}/#{i}"
        end
      end

      module SchemaVersion
        def self.example
          '11'
        end
      end
    end
  end
end
