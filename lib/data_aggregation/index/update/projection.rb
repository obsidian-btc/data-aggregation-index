module DataAggregation::Index
  module Update
    module Projection
      class PublishEvent
        include EventStore::EntityProjection
        include Messages

        apply Initiated do |update_initiated|
          entity.event_id = update_initiated.update_id
          entity.event_data_text = update_initiated.update_data
        end

        apply Started do |started|
          entity.reference_stream_position = started.data_stream_position
        end
      end

      class StartReference
        include EventStore::EntityProjection
        include Messages

        apply Initiated do |update_initiated|
          entity.related_entity_id = update_initiated.update_id
          entity.destination_stream_name = update_initiated.update_data
        end

        apply Started do |started|
          entity.event_stream_position = started.data_stream_position
        end
      end
    end
  end
end
