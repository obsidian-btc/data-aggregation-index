module DataAggregation::Index
  class PublishEvent
    include Telemetry::Logger::Dependency
    include StreamName

    configure :publish_event

    attr_reader :category

    dependency :clock, Clock::UTC
    dependency :get_positions, GetPositions
    dependency :update_store, Update::Store
    dependency :writer, EventStore::Messaging::Writer

    def initialize(category)
      @category = category
    end

    def self.build(category)
      instance = new category
      Clock::UTC.configure instance
      GetPositions.configure instance
      Update::Store.configure instance
      EventStore::Messaging::Writer.configure instance
      instance
    end

    def call(entity_id, event, event_id=nil)
      log_attributes = "EntityID: #{entity_id}, MessageType: #{event.message_type}"
      logger.trace "Publishing event (#{log_attributes})"

      event_data = EventStore::Messaging::Message::Export::EventData.(event)
      event_data.id = event_id if event_id

      event_id = event_data.id

      update = update_store.get event_id

      if update
        logger.debug "Event already published (#{log_attributes})"
        return
      end

      _, event_list_pos, _ = get_positions.(entity_id, category)

      event_data_text = Serialize::Write.(event_data, :json)

      publish_event_initiated = Update::Messages::PublishEventInitiated.proceed event, copy: false
      publish_event_initiated.entity_id = entity_id
      publish_event_initiated.event_id = event_id
      publish_event_initiated.event_data_text = event_data_text
      publish_event_initiated.time = clock.iso8601
      publish_event_initiated.event_list_position = event_list_pos unless event_list_pos == :no_stream

      stream_name = update_stream_name event_id, category

      writer.write_initial publish_event_initiated, stream_name

      logger.debug "Event published (#{log_attributes}, EventID: #{event_id})"

      publish_event_initiated
    end
  end
end
