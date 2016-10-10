module DataAggregation::Index::Controls
  module SourceEvent
    module Metadata
      def self.example
        metadata = EventStore::Messaging::Message::Metadata.build
        metadata.source_event_uri = SourceEventURI.example
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
        def self.example
          stream_name = StreamName::Entity.example

          "streams/#{stream_name}/0"
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
