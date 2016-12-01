require_relative '../../automated_init'

context "Copy batch operation, subsequent batch is copied" do
  batch_assembled = Controls::Update::Messages::BatchAssembled.example 1
  category = Controls::StreamName::Category.example

  update = Controls::Update::Entity::Copying.example 1

  copy_batch = Update::CopyBatch.new batch_assembled, category
  copy_batch.clock.now = Controls::Time::Raw.example
  copy_batch.store.add update.update_id, update, 11

  copy_batch.()

  context "All events in batch are copied" do
    batch_data = Controls::Update::Batch::Data.example 1

    batch_data.each_with_index do |data, index|
      test "Batch entry ##{index} is copied" do
        assert copy_batch.copy do
          copied?(data)
        end
      end
    end
  end
end
