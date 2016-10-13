require_relative '../../bench_init'

context "Adding the first event to an event list" do
  category = Controls::StreamName::Category.example
  publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example 0

  add = EventList::Add.new publish_event_initiated, category
  add.clock.now = Controls::Time::Raw.example

  add.()

  test "Event added message is written to event list stream" do
    event_added = Controls::EventList::Messages::Added.example 0
    event_list_stream_name = Controls::StreamName::EventList.example

    assert add.writer do
      written? do |msg, stream_name|
        msg == event_added && stream_name == event_list_stream_name
      end
    end
  end

  test "Event added message is expected to initiate stream" do
    assert add.writer do
      written? do |_, _, expected_version|
        expected_version == :no_stream
      end
    end
  end
end