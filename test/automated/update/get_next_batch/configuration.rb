require_relative '../../automated_init'

context "Get next batch operation is configured" do
  update_stream = Controls::StreamName::Update.example random: true

  batch_copied = Controls::Update::Messages::BatchCopied.example
  event_data = Controls::EventData.example stream_name: update_stream

  write = Messaging::EventStore::Write.build
  write.(Controls::Update::Messages::PublishEventInitiated.example, update_stream)

  context "Session is specified" do
    session = EventSource::EventStore::HTTP::Session.build

    get_next_batch = Update::GetNextBatch.build(
      batch_copied,
      event_data,
      session: session
    )

    test "Session is passed to.write" do
      assert get_next_batch.write do
        session? session
      end
    end

    test "Session is passed to store" do
      assert get_next_batch.store do
        session? session
      end
    end

    test "Session is passed to query" do
      assert get_next_batch.query do
        session? session
      end
    end
  end
end
