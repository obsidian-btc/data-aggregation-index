module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        class References < Query
          def call(entity_id, starting_position, ending_position)
            stream_name = reference_list_stream_name entity_id, category

            log_attributes = "EntityID: #{entity_id}, StartingPosition: #{starting_position}, EndingPosition: #{ending_position}, StreamName: #{stream_name})"
            logger.trace "Querying references batch (#{log_attributes})"

            related_entity_stream_names = []

            Projection.(
              related_entity_stream_names,
              stream_name,
              starting_position: starting_position,
              ending_position: ending_position,
              session: session
            )

            logger.debug "References batch has been queried (#{log_attributes})"

            related_entity_stream_names
          end

          class Projection
            include EventStore::EntityProjection
            include DataAggregation::Index::ReferenceList::Messages

            apply Added do |added|
              related_entity_stream_name = StreamName.stream_name(
                added.related_entity_id,
                added.related_entity_category
              )

              entity << related_entity_stream_name
            end
          end
        end
      end
    end
  end
end
