require_relative '../../automated_init'

context "Add reference update, started event is projected onto entity" do
  entity = Controls::Update::Entity::AddReference::Initiated.example

  projection = Update::Projection.new entity

  started = Controls::Update::Messages::Started.example event_list_position: true
  projection.(started)

  test "Event stream position is set" do
    assert entity.list_position == Controls::Position::EventList.example
  end

  test "Entity has started" do
    assert entity.started?
  end
end
