require_relative '../bench_init'

context "Adding event to an event list, event is already added" do
  category = Controls::StreamName::Category.example
  event_id = Controls::ID::SourceEvent.example
  publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example
  event_list_stream_name = Controls::StreamName::EventList.example
  event_list_version = Controls::Position::EventList::Initial.example

  add = EventList::Add.new publish_event_initiated, category
  add.recent_event_added_query.set(
    event_list_stream_name,
    event_id,
    version: event_list_version
  )

  add.()

  test "Nothing is written" do
    refute add.writer do
      written?
    end
  end
end
