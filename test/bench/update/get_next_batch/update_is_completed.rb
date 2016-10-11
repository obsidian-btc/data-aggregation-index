require_relative '../../bench_init'

context "Get next batch assembles a batch, but update is completed" do
  entity_id = Controls::ID::Entity.example
  event = Controls::Update::Messages::Started.example
  category = Controls::StreamName::Category.example

  update = Controls::Update::Entity::Completed.example

  get_next_batch = Update::GetNextBatch.new event, category
  get_next_batch.store.add update.update_id, update

  get_next_batch.()

  test "Nothing is writetn" do
    refute get_next_batch.writer do
      written?
    end
  end
end
