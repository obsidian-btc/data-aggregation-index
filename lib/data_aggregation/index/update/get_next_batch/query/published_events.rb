module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        class PublishedEvents < Query
          def call(entity_id, starting_position, ending_position)
            log_attributes = "EntityID: #{entity_id}, StartingPosition: #{starting_position}, EndingPosition: #{ending_position})"
            logger.trace "Querying published events batch (#{log_attributes})"

            published_events = []

            stream_name = event_list_stream_name entity_id, category

            Projection.(
              published_events,
              stream_name,
              starting_position: starting_position,
              ending_position: ending_position
            )

            logger.debug "Published events batch has been queried (#{log_attributes})"

            published_events
          end

          class Projection
            include EventStore::EntityProjection
            include DataAggregation::Index::Messages

            apply EventAdded do |event_added|
              entity << event_added.event_data_text
            end
          end
        end
      end
    end
  end
end
