require_relative '../../bench_init'

context "Get next batch assembles a batch" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example

  context "Initial batch is assembled" do
    update = Controls::Update::Entity::Started.example
    event = Controls::Update::Messages::Started.example

    batch_data = Controls::Update::BatchData.example

    get_next_batch = Update::GetNextBatch.new event, category
    get_next_batch.batch_size = Controls::Position::Batch::Size.example
    get_next_batch.store.add update.update_id, update, 11
    get_next_batch.query.add entity_id, batch_data
    get_next_batch.clock.now = Controls::Time::Raw.example

    get_next_batch.()

    test "Batch assembled event is written to update stream" do
      batch_assembled = Controls::Update::Messages::BatchAssembled.example
      update_stream_name = Controls::StreamName::Update.example

      assert get_next_batch.writer do
        written? do |msg, stream_name|
          msg == batch_assembled && stream_name == update_stream_name
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

  context "Subsequent batch is assembled" do
    update = Controls::Update::Entity::Assembling.example
    event = Controls::Update::Messages::BatchCopied.example

    batch_data = Controls::Update::BatchData.example

    get_next_batch = Update::GetNextBatch.new event, category
    get_next_batch.store.add update.update_id, update
    get_next_batch.query.add entity_id, batch_data, update.batch_position.next

    batch_assembled = get_next_batch.()

    test "Batch assembled event is written" do
      assert get_next_batch.writer do
        written? do |msg|
          msg == batch_assembled
        end
      end
    end
  end
end
