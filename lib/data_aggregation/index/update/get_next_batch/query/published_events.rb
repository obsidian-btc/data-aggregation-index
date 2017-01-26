module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        class PublishedEvents < Query
          def call(entity_id, starting_position, ending_position)
            stream_name = event_list_stream_name entity_id, category

            log_attributes = "EntityID: #{entity_id}, StartingPosition: #{starting_position}, EndingPosition: #{ending_position}, StreamName: #{stream_name})"
            logger.trace "Querying published events batch (#{log_attributes})"

            published_events = []

            projection = Projection.build published_events

            EventSource::EventStore::HTTP::Read.(stream_name, position: starting_position, session: session) do |event_data|
              projection.(event_data)
              break if event_data.position == ending_position
            end

            logger.debug "Published events batch has been queried (#{log_attributes})"

            published_events
          end

          class Projection
            include EventStore::EntityProjection
            include DataAggregation::Index::EventList::Messages

            apply Added do |added|
              entity << added.event_data_text
            end
          end
        end
      end
    end
  end
end
