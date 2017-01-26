require_relative '../../automated_init'

context "Copy batch operation is configured" do
  update_stream = Controls::StreamName::Update.example random: true

  batch_assembled = Controls::Update::Messages::BatchAssembled.example stream_name: update_stream

  write = Messaging::EventStore::Write.build
  write.(Controls::Update::Messages::PublishEventInitiated.example, update_stream)

  context "Session is specified" do
    session = EventSource::EventStore::HTTP::Session.build

    copy_batch = Update::CopyBatch.build batch_assembled, session: session

    test "Session is passed to.write" do
      assert copy_batch.write do
        session? session
      end
    end

    test "Session is passed to store" do
      assert copy_batch.store do
        session? session
      end
    end

    test "Session is passed to copy" do
      assert copy_batch.copy do
        session? session
      end
    end
  end
end
