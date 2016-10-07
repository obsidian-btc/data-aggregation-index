require_relative '../../bench_init'

context "Start reference update, initiated event is projected onto entity" do
  entity = Update::Entity::StartReference.new

  projection = Update::Projection::StartReference.new entity

  initiated = Controls::Update::Messages::Initiated::StartReference.example
  projection.apply initiated

  test "Related entity ID is set" do
    assert entity.related_entity_id == Controls::ID::RelatedEntity.example
  end

  test "Destination stream name is set" do
    assert entity.destination_stream_name == Controls::StreamName::RelatedEntity.example
  end
end
