require_relative '../../bench_init'

context "Adding event to an event list" do
  category = Controls::StreamName::Category.example
  publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example
  event_list_stream_name = Controls::StreamName::EventList.example

  add = EventList::Add.new publish_event_initiated, category
  add.clock.now = Controls::Time::Raw.example
  add.get_recent_event.set event_list_stream_name, version: 11

  add.()

  test "Event added message is written to event list stream" do
    event_added = Controls::EventList::Messages::Added.example

    assert add.writer do
      written? do |msg, stream_name|
        msg == event_added && stream_name == event_list_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert add.writer do
      written? do |_, _, expected_version|
        expected_version == 11
      end
    end
  end
end
