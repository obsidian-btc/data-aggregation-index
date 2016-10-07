require_relative '../../bench_init'

context "Start reference update, started event is projected onto entity" do
  entity = Controls::Update::Entity::StartReference::Initiated.example

  projection = Update::Projection.new entity

  started = Controls::Update::Messages::Started.example
  projection.apply started

  test "Event stream position is set" do
    assert entity.event_stream_position == Controls::Position::EventList.example
  end
end
