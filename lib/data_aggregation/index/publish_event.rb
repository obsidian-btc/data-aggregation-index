module DataAggregation::Index
  class PublishEvent
    include Log::Dependency
    include StreamName

    configure :publish_event

    attr_reader :category

    dependency :clock, Clock::UTC
    dependency :get_positions, Queries::GetPositions
    dependency :update_store, Update::Store
    dependency :write, Messaging::EventStore::Write

    def initialize(category)
      @category = category
    end

    def self.build(category)
      instance = new category
      Clock::UTC.configure instance
      Queries::GetPositions.configure instance
      Messaging::EventStore::Write.configure instance
      Update::Store.configure instance, category, attr_name: :update_store
      instance
    end

    def call(entity_id, event)
      log_attributes = "EntityID: #{entity_id}, MessageType: #{event.message_type}, SourceEventStream: #{event.metadata.source_event_stream_name.inspect}, SourceEventPosition: #{event.metadata.source_event_position.inspect}"
      logger.trace "Publishing event (#{log_attributes})"

      event_id = get_event_id event

      event_data = Messaging::Message::Export.(event)
      event_data.id = event_id

      update = update_store.get event_id

      if update
        logger.debug "Event already published (#{log_attributes}, EventID: #{event_id})"
        return
      end

      _, event_list_pos, _ = get_positions.(entity_id, category)

      raw_data = EventData::Transformer.raw_data event_data
      event_data_text = EventData::Transformer::JSON.write raw_data

      publish_event_initiated = Update::Messages::PublishEventInitiated.follow event, strict: false
      publish_event_initiated.entity_id = entity_id
      publish_event_initiated.event_id = event_id
      publish_event_initiated.event_data_text = event_data_text
      publish_event_initiated.time = clock.iso8601
      publish_event_initiated.event_list_position = event_list_pos unless event_list_pos == :no_stream

      stream_name = update_stream_name event_id, category

      write.initial publish_event_initiated, stream_name

      logger.debug "Event published (#{log_attributes}, EventID: #{event_id})"

      publish_event_initiated
    end

    def get_event_id(event)
      stream_id = Messaging::StreamName.get_id event.metadata.source_event_stream_name
      stream_position = event.metadata.source_event_position

      "#{stream_id}-#{stream_position}"
    end
  end
end
