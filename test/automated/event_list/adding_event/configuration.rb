require_relative '../../automated_init'

context "Add event to event list command is configured" do
  publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example
  event_data = Controls::EventData::Update.example

  add = EventList::Add.build publish_event_initiated, event_data

  test "Category is set" do
    assert add.category == Controls::StreamName::Category.example
  end
end
