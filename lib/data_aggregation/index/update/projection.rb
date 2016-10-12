module DataAggregation::Index
  module Update
    class Projection
      include EventStore::EntityProjection
      include Messages

      apply PublishEventInitiated do |initiated|
        entity.extend Entity::PublishEvent

        entity.entity_id = initiated.entity_id
        entity.event_id = initiated.event_id
        entity.event_data_text = initiated.event_data_text
      end

      apply AddReferenceInitiated do |initiated|
        entity.extend Entity::AddReference

        entity.entity_id = initiated.entity_id
        entity.related_entity_id = initiated.related_entity_id
        # XXX
        entity.destination_stream_name = StreamName.stream_name initiated.related_entity_id, initiated.related_entity_category
        # /XXX
      end

      apply Started do |started|
        entity.record_started started
      end

      apply BatchAssembled do |batch_assembled|
        entity.batch_position = batch_assembled.batch_position
      end

      apply BatchCopied do |batch_copied|
        entity.copy_position = batch_copied.copy_position
      end

      apply Completed do |_|
        entity.record_completed
      end
    end
  end
end
