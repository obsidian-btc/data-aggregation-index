require_relative '../../bench_init'

context "Copy batch operation" do
  batch_assembled = Controls::Update::Messages::BatchAssembled.example
  category = Controls::StreamName::Category.example

  update = Controls::Update::Entity::Copying.example

  copy_batch = Update::CopyBatch.new batch_assembled, category
  copy_batch.clock.now = Controls::Time::Raw.example
  copy_batch.store.add update.update_id, update, 11

  copy_batch.()

  context "All events in batch are copied" do
    batch_data = Controls::Update::Batch::Data.example

    batch_data.each_with_index do |data, index|
      test "Batch entry ##{index} is copied" do
        assert copy_batch.copy do
          copied?(data)
        end
      end
    end
  end

  test "Batch copied event is written to update stream" do
    batch_copied = Controls::Update::Messages::BatchCopied.example
    update_stream_name = Controls::StreamName::Update.example

    assert copy_batch.writer do
      written? do |msg, stream_name|
        msg == batch_copied && stream_name == update_stream_name
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
