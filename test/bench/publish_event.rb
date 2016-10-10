require_relative './bench_init'

context "Event is published to index" do
  source_event = Controls::SourceEvent.example
  category = Controls::StreamName::Category.example

  publish_event = PublishEvent.new category
  publish_event.clock.now = Controls::Time::Raw.example

  event_written = publish_event.(source_event)

  test "PublishEvent initiated message is written to update stream" do
    publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example event_id: event_written.event_id
    update_stream_name = Controls::StreamName::Update::PublishEvent.example event_id: event_written.event_id

    assert publish_event.writer do
      written? do |msg, stream_name|
        msg == publish_event_initiated && stream_name == update_stream_name
      end
    end
  end
end
