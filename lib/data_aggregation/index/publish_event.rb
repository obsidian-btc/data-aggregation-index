module DataAggregation::Index
  class PublishEvent
    include Telemetry::Logger::Dependency
    include StreamName

    attr_reader :category

    dependency :clock, Clock::UTC
    dependency :update_store, Update::Store
    dependency :writer, EventStore::Messaging::Writer

    def initialize(category)
      @category = category
    end

    def self.build(category)
      instance = new category
      Clock::UTC.configure instance
      Update::Store.configure instance
      EventStore::Messaging::Writer.configure instance
      instance
    end

    def call(event, event_id=nil)
      log_attributes = "MessageType: #{event.message_type}"
      logger.trace "Publishing event (#{log_attributes})"

      event_data = EventStore::Messaging::Message::Export::EventData.(event)
      event_data.id = event_id if event_id

      event_id = event_data.id

      update = update_store.get event_id

      if update
        logger.debug "Event already published (#{log_attributes})"
        return
      end

      event_data_text = Serialize::Write.(event_data, :json)

      publish_event_initiated = Update::Messages::PublishEventInitiated.proceed event, copy: false
      publish_event_initiated.event_id = event_id
      publish_event_initiated.event_data_text = event_data_text
      publish_event_initiated.time = clock.iso8601

      stream_name = update_stream_name event_id, category

      writer.write_initial publish_event_initiated, stream_name

      logger.debug "Event published (#{log_attributes}, EventID: #{event_id})"

      publish_event_initiated
    end
  end
end
