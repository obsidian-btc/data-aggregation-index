require_relative '../../automated_init'

context "Publish event update, started event is projected onto entity" do
  entity = Controls::Update::Entity::PublishEvent::Initiated.example

  projection = Update::Projection.new entity

  started = Controls::Update::Messages::Started.example reference_list_position: true
  projection.(started)

  test "List position is set" do
    assert entity.list_position == Controls::Position::ReferenceList.example
  end

  test "Entity has started" do
    assert entity.started?
  end
end
