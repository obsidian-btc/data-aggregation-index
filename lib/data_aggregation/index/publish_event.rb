module DataAggregation::Index
  class PublishEvent
    include Telemetry::Logger::Dependency
    include StreamName

    configure :publish_event

    attr_reader :category

    dependency :clock, Clock::UTC
    dependency :get_positions, Queries::GetPositions
    dependency :update_store, Update::Store
    dependency :writer, EventStore::Messaging::Writer

    def initialize(category)
      @category = category
    end

    def self.build(category)
      instance = new category
      Clock::UTC.configure instance
      Queries::GetPositions.configure instance
      EventStore::Messaging::Writer.configure instance
      Update::Store.configure instance, category, attr_name: :update_store
      instance
    end

    def call(entity_id, event)
      log_attributes = "EntityID: #{entity_id}, MessageType: #{event.message_type}, SourceEventURI: #{event.metadata.source_event_uri.inspect}"
      logger.trace "Publishing event (#{log_attributes})"

      event_id = get_event_id event

      event_data = EventStore::Messaging::Message::Export::EventData.(event)
      event_data.id = event_id

      update = update_store.get event_id

      if update
        logger.debug "Event already published (#{log_attributes}, EventID: #{event_id})"
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

    def get_event_id(event)
      source_event_uri = URI.parse event.metadata.source_event_uri

      path = source_event_uri.path

      _, stream_id = path.split '-', 2

      stream_id.sub! '/', '-'

      stream_id
    end
  end
end
