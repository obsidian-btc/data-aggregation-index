require_relative '../../automated_init'

context "Add event to event list command is configured" do
  publish_event_initiated = Controls::Update::Messages::PublishEventInitiated.example
  event_data = Controls::EventData::Update.example

  context do
    add = EventList::Add.build publish_event_initiated, event_data

    test "Category is set" do
      assert add.category == Controls::StreamName::Category.example
    end
  end

  context "Session is specified" do
    session = Object.new

    add = EventList::Add.build publish_event_initiated, event_data, session: session

    test "Session is passed to writer" do
      assert add.writer do
        session? session
      end
    end
  end
end
