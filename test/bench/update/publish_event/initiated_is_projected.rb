require_relative '../../bench_init'

context "Publish event update, initiated event is projected onto entity" do
  entity = Update::Entity::PublishEvent.new

  projection = Update::Projection::PublishEvent.new entity

  initiated = Controls::Update::Messages::Initiated::PublishEvent.example
  projection.apply initiated

  test "Event ID is set" do
    assert entity.event_id == Controls::ID::Event.example
  end

  test "Event data text is set" do
    assert entity.event_data_text == Controls::EventData::Text.example
  end
end
