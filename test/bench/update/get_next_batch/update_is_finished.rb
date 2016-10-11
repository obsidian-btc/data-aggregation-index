require_relative '../../bench_init'

context "Get next batch assembles a batch, but update is finished" do
  entity_id = Controls::ID::Entity.example
  event = Controls::Update::Messages::Started.example
  category = Controls::StreamName::Category.example

  update = Controls::Update::Entity::Finished.example

  get_next_batch = Update::GetNextBatch.new event, category
  get_next_batch.store.add update.update_id, update, 11
  get_next_batch.clock.now = Controls::Time::Raw.example

  get_next_batch.()

  test "Completed is written to update stream" do
    completed = Controls::Update::Messages::Completed.example
    update_stream_name = Controls::StreamName::Update.example

    assert get_next_batch.writer do
      written? do |msg, stream_name|
        msg == completed && stream_name == update_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert get_next_batch.writer do
      written? do |_, _, expected_version|
        expected_version == 11
      end
    end
  end
end
