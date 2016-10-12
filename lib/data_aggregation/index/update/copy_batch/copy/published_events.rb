module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        class PublishedEvents < Copy
          alias_method :event_data_list, :batch_data

          def call
            log_attributes = "RelatedEntityStreamName: #{related_entity_stream_name}, EventDataListCount: #{event_data_list.count}"
            logger.trace "Copying published events (#{log_attributes})"

            event_data_list.each do |event_data_text|
              event_data = Serialize::Read.(event_data_text, :json, EventData)
              copy_message.(event_data, related_entity_stream_name)
            end

            logger.debug "Published events copied (#{log_attributes})"
          end

          def related_entity_stream_name
            update.related_entity_stream_name
          end
        end
      end
    end
  end
end
