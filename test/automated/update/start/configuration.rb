require_relative '../../automated_init'

context "Start update operation is configured" do
  update_started = Controls::Messages::UpdateStarted.example
  event_data = Controls::EventData.example

  context "Session is specified" do
    session = EventSource::EventStore::HTTP::Session.build

    start = Update::Start.build update_started, event_data, session: session

    test "Session is passed to writer" do
      assert start.writer do
        session? session
      end
    end

    test "Session is passed to store" do
      assert start.update_store do
        session? session
      end
    end
  end
end
