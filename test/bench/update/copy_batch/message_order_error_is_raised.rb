require_relative '../../bench_init'

context "Copy batch operation, message order error is raised during a copy" do
  batch_assembled = Controls::Update::Messages::BatchAssembled.example
  category = Controls::StreamName::Category.example

  update = Controls::Update::Entity::Copying.example

  context do
    messages_copied = Controls::Update::Messages::CopyFailed::MessagesCopied.example

    copy_batch = Update::CopyBatch.new batch_assembled, category
    copy_batch.store.add update.update_id, update, 11
    copy_batch.clock.now = Controls::Time::Raw.example
    copy_batch.copy.raise_message_order_error(
      Controls::Update::Batch::Data::Entry.example(offset: messages_copied)
    )

    copy_batch.()

    test "Copy failed event is written to update stream" do
      copy_failed = Controls::Update::Messages::CopyFailed.example messages_copied: messages_copied
      update_stream_name = Controls::StreamName::Update.example

      assert copy_batch.writer do
        written? do |msg, stream_name|
          msg == copy_failed && stream_name == update_stream_name
        end
      end
    end

    test "Expected version is set" do
      assert copy_batch.writer do
        written? do |_, _, expected_version|
          expected_version == 11
        end
      end
    end
  end

  context "Copy fails on first entry" do
    copy_batch = Update::CopyBatch.new batch_assembled, category
    copy_batch.store.add update.update_id, update
    copy_batch.copy.raise_message_order_error(
      Controls::Update::Batch::Data::Entry.example
    )

    copy_failed = copy_batch.()

    test "Batch copied event is written" do
      assert copy_batch.writer do
        written? { |msg| msg == copy_failed }
      end
    end

    test "Copy position is set to entity copy position" do
      assert copy_failed.copy_position == nil
    end

    test "All batch data previously assembled is transferred" do
      assert copy_failed.batch_data == batch_assembled.batch_data
    end
  end
end
