module DataAggregation::Index::Controls
  module SourceEvent
    module Metadata
      def self.example(entity_id: nil)
        metadata = EventStore::Messaging::Message::Metadata.build
        metadata.source_event_uri = SourceEventURI.example entity_id: entity_id
        metadata.causation_event_uri = CausationEventURI.example
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
          11
        end
      end
    end
  end
end
