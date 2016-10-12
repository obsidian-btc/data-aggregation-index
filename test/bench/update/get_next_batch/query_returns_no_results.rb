require_relative '../../bench_init'

context "Get next batch assembles a batch, query returns no results" do
  update = Controls::Update::Entity::Started.example
  event = Controls::Update::Messages::Started.example
  category = Controls::StreamName::Category.example

  get_next_batch = Update::GetNextBatch.new event, category
  get_next_batch.store.add update.update_id, update

  test "Error is raised" do
    assert proc { get_next_batch.() } do
      raises_error? Update::GetNextBatch::EmptyRead
    end
  end
end
