module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        class Reference < Copy
          def call(related_entity_stream_name)
            logger.trace "Copying event data (RelatedEntityStreamName: #{related_entity_stream_name})"

            copy_message.(event_data, related_entity_stream_name)

            logger.debug "Event data copied (RelatedEntityStreamName: #{related_entity_stream_name})"
          end

          def event_data
            @event_data ||= Serialize::Read.(update.event_data_text, :json, EventData)
          end
        end
      end
    end
  end
end
