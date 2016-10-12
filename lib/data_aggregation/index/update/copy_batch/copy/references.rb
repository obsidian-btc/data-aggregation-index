module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        class References < Copy
          alias_method :destination_stream_names, :batch_data

          def call
            logger.trace "Copying event data (DestinationStreamNamesCount: #{destination_stream_names.count})"

            destination_stream_names.each do |stream_name|
              copy_message.(event_data, stream_name)
            end

            logger.debug "Event data copied (DestinationStreamNamesCount: #{destination_stream_names.count})"
          end

          def event_data
            @event_data ||= Serialize::Read.(update.event_data_text, :json, EventData)
          end
        end
      end
    end
  end
end
