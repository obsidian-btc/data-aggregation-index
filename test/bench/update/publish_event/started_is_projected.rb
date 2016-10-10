require_relative '../../bench_init'

context "Publish event update, started event is projected onto entity" do
  entity = Controls::Update::Entity::PublishEvent::Initiated.example

  projection = Update::Projection.new entity

  started = Controls::Update::Messages::Started.example
  projection.apply started

  test "Reference stream position is set" do
    assert entity.reference_stream_position == Controls::Position::ReferenceList::Update.example
  end
end
