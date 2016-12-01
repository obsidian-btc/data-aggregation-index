require_relative '../../automated_init'

context "Get next batch, batch is already assembled" do
  category = Controls::StreamName::Category.example
  batch_size = Controls::Update::Batch::Size.example

  context "Initial batch is already assembled" do
    update = Controls::Update::Entity::Copying.example
    event = Controls::Update::Messages::Started.example

    get_next_batch = Update::GetNextBatch.new event, category
    get_next_batch.batch_size = batch_size
    get_next_batch.store.add update.update_id, update

    get_next_batch.()

    test "Nothing is written" do
      refute get_next_batch.writer do
        written?
      end
    end
  end

  context "Subsequent batch is already assembled" do
    update = Controls::Update::Entity::Copying.example 1
    event = Controls::Update::Messages::BatchCopied.example

    get_next_batch = Update::GetNextBatch.new event, category
    get_next_batch.batch_size = batch_size
    get_next_batch.store.add update.update_id, update

    get_next_batch.()

    test "Nothing is written" do
      refute get_next_batch.writer do
        written?
      end
    end
  end
end
