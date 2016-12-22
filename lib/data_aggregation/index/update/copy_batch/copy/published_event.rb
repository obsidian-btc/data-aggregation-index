module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        class PublishedEvent < Copy
          def call(event_data_text)
            logger.trace "Copying published event (RelatedEntityStreamName: #{related_entity_stream_name})"

            event_data = Transform::Read.(event_data_text, :json, EventData)
            copy_message.(event_data, related_entity_stream_name)

            logger.debug "Published event copied (RelatedEntityStreamName: #{related_entity_stream_name})"
          end

          def related_entity_stream_name
            update.related_entity_stream_name
          end
        end
      end
    end
  end
end
