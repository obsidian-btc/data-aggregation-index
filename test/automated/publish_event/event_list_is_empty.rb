require_relative '../automated_init'

context "Event is published to index, event list is empty" do
  entity_id = Controls::ID::Entity.example

  source_event = Controls::SourceEvent.example
  category = Controls::StreamName::Category.example

  publish_event = PublishEvent.new category
  publish_event.clock.now = Controls::Time::Raw.example

  publish_event.(entity_id, source_event)

  test "PublishEvent initiated message is written to update stream" do
    publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example list_position: false
    update_stream_name = Controls::StreamName::Update::PublishEvent.example

    assert publish_event.write do
      written? do |msg, stream_name|
        msg == publish_event_initiated && stream_name == update_stream_name
      end
    end
  end
end
