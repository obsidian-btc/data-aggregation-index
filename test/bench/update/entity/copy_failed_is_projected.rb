require_relative '../../bench_init'

context "Copy failed event is projected onto update entity" do
  copy_failed = Controls::Update::Messages::CopyFailed.example
  entity = Controls::Update::Entity::Copying.example

  projection = Update::Projection.new entity
  projection.apply copy_failed

  test "Copy position is increased" do
    control_position = Controls::Update::Batch::Position::Failed.example

    assert entity.copy_position == control_position
  end
end
