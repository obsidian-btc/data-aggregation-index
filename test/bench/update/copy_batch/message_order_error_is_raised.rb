require_relative '../../bench_init'

context "Copy batch operation, message order error is raised during a copy" do
  batch_assembled = Controls::Update::Messages::BatchAssembled.example
  category = Controls::StreamName::Category.example

  update = Controls::Update::Entity::Copying.example

  context do
    copy_batch = Update::CopyBatch.new batch_assembled, category
    copy_batch.store.add update.update_id, update
    copy_batch.copy.raise_message_order_error(
      Controls::Update::Batch::Data::Entry.example(offset: 2)
    )

    batch_copied = copy_batch.()

    test "Batch copied event is written" do
      assert copy_batch.writer do
        written? { |msg| msg == batch_copied }
      end
    end

    test "Copy position is set to last event successfully copied" do
      assert batch_copied.copy_position == 1
    end
  end

  context "Copy fails on first entry" do
    copy_batch = Update::CopyBatch.new batch_assembled, category
    copy_batch.store.add update.update_id, update
    copy_batch.copy.raise_message_order_error(
      Controls::Update::Batch::Data::Entry.example
    )

    batch_copied = copy_batch.()

    test "Batch copied event is written" do
      assert copy_batch.writer do
        written? { |msg| msg == batch_copied }
      end
    end

    test "Copy position is set to entity copy position" do
      assert batch_copied.copy_position == nil
    end
  end
end
