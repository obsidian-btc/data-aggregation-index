module DataAggregation::Index
  module Update
    class Projection
      include EventStore::EntityProjection
      include Messages

      apply PublishEventInitiated do |initiated|
        entity.extend Entity::PublishEvent

        entity.event_id = initiated.event_id
        entity.event_data_text = initiated.event_data_text
      end

      apply StartReferenceInitiated do |initiated|
        entity.extend Entity::StartReference

        entity.related_entity_id = initiated.related_entity_id
        entity.destination_stream_name = initiated.destination_stream_name
      end

      apply Started do |started|
        entity.record_started started
      end
    end
  end
end
