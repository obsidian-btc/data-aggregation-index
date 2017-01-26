require_relative '../../automated_init'

context "Batch assembled event is projected onto update entity" do
  batch_assembled = Controls::Update::Messages::BatchAssembled.example
  entity = Controls::Update::Entity::Started.example

  projection = Update::Projection.new entity
  projection.(batch_assembled)

  test "Batch position is increased" do
    assert entity.batch_position == Controls::Update::Batch::Position::Stop.example
  end
end
