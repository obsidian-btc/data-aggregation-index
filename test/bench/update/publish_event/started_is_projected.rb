require_relative '../../bench_init'

context "Publish event update, started event is projected onto entity" do
  entity = Update::Entity::PublishEvent.new

  projection = Update::Projection::PublishEvent.new entity

  started = Controls::Update::Messages::Started::PublishEvent.example
  projection.apply started

  test "Reference stream position is set" do
    assert entity.reference_stream_position == Controls::Position::ReferenceList.example
  end
end
