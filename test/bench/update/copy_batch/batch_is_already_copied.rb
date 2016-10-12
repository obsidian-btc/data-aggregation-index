require_relative '../../bench_init'

context "Copy batch operation, batch is already copied" do
  batch_assembled = Controls::Update::Messages::BatchAssembled.example
  category = Controls::StreamName::Category.example

  update = Controls::Update::Entity::Assembling.example

  copy_batch = Update::CopyBatch.new batch_assembled, category
  copy_batch.store.add update.update_id, update

  copy_batch.()

  test "Nothing is copied" do
    refute copy_batch.copy do
      copied?
    end
  end

  test "Nothing is written" do
    refute copy_batch.writer do
      written?
    end
  end
end
