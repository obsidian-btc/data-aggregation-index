require_relative '../../bench_init'

context "Completed event is projected onto update entity" do
  completed = Controls::Update::Messages::Completed.example
  entity = Controls::Update::Entity::Started.example

  projection = Update::Projection.new entity
  projection.apply completed

  test "Completed predicate returns true" do
    assert entity.completed?
  end
end