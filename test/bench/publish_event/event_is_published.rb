require_relative '../bench_init'

context "Event is published to index" do
  entity_id = Controls::ID::Entity.example

  source_event = Controls::SourceEvent.example
  category = Controls::StreamName::Category.example
  event_id = Controls::ID::SourceEvent.example
  index_stream_name = Controls::StreamName::Index.example

  event_list_position = Controls::Position::EventList::Initial.example

  publish_event = PublishEvent.new category
  publish_event.get_positions.set index_stream_name, 0, event_list_position, 0
  publish_event.clock.now = Controls::Time::Raw.example

  event_written = publish_event.(entity_id, source_event, event_id)

  test "PublishEvent initiated message is written to update stream" do
    publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example
    update_stream_name = Controls::StreamName::Update::PublishEvent.example

    assert publish_event.writer do
      written? do |msg, stream_name|
        msg == publish_event_initiated && stream_name == update_stream_name
      end
    end
  end
end
