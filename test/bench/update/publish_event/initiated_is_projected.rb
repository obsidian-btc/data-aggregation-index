require_relative '../../bench_init'

context "Publish event update, initiated event is projected onto entity" do
  entity = Update::Entity.new

  projection = Update::Projection.new entity

  initiated = Controls::Update::Messages::PublishEventInitiated.example
  projection.apply initiated

  test "Entity is specialized for publishing the event" do
    assert entity.is_a?(Update::Entity::PublishEvent)
  end

  test "Event ID is set" do
    assert entity.event_id == Controls::ID::Event.example
  end

  test "Event data text is set" do
    assert entity.event_data_text == Controls::EventData::Text.example
  end

  test "Control" do
    assert entity == Controls::Update::Entity::PublishEvent::Initiated.example
  end
end
