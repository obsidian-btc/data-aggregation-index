module DataAggregation::Index
  class PublishEvent
    include StreamName

    attr_reader :category

    dependency :clock, Clock::UTC
    dependency :writer, EventStore::Messaging::Writer

    def initialize(category)
      @category = category
    end

    def call(event)
      event_data = EventStore::Messaging::Message::Export::EventData.(event)
      event_id = event_data.id

      event_data_text = Serialize::Write.(event_data, :json)

      publish_event_initiated = Update::Messages::PublishEventInitiated.new
      publish_event_initiated.event_id = event_id
      publish_event_initiated.event_data_text = event_data_text
      publish_event_initiated.time = clock.iso8601

      stream_name = update_stream_name event_id, category

      writer.write_initial publish_event_initiated, stream_name

      publish_event_initiated
    end
  end
end
