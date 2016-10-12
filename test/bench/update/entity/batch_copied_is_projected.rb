require_relative '../../bench_init'

context "Batch copied event is projected onto update entity" do
  batch_copied = Controls::Update::Messages::BatchCopied.example
  entity = Controls::Update::Entity::Copying.example

  projection = Update::Projection.new entity
  projection.apply batch_copied

  test "Copy position is increased" do
    assert entity.copy_position == Controls::Update::Batch::Position::Stop.example
  end
end
