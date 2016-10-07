require_relative '../../bench_init'

context "Start reference update, started event is projected onto entity" do
  entity = Update::Entity::StartReference.new

  projection = Update::Projection::StartReference.new entity

  started = Controls::Update::Messages::Started::StartReference.example
  projection.apply started

  test "Event stream position is set" do
    assert entity.event_stream_position == Controls::Position::EventList.example
  end
end
