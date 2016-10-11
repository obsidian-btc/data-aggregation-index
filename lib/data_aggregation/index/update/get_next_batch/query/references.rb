module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        class References < Query
          def call(entity_id, starting_position, ending_position)
            log_attributes = "EntityID: #{entity_id}, StartingPosition: #{starting_position}, EndingPosition: #{ending_position})"
            logger.trace "Querying references batch (#{log_attributes})"

            destination_stream_names = []

            stream_name = reference_list_stream_name entity_id, category

            Projection.(
              destination_stream_names,
              stream_name,
              starting_position: starting_position,
              ending_position: ending_position
            )

            logger.debug "References batch has been queried (#{log_attributes})"

            destination_stream_names
          end

          class Projection
            include EventStore::EntityProjection
            include DataAggregation::Index::Messages

            apply ReferenceAdded do |reference_added|
              entity << reference_added.destination_stream_name
            end
          end
        end
      end
    end
  end
end
