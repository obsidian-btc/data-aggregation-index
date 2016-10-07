require_relative '../../bench_init'

context "Start reference update, initiated event is projected onto entity" do
  entity = Update::Entity.new

  projection = Update::Projection.new entity

  initiated = Controls::Update::Messages::StartReferenceInitiated.example
  projection.apply initiated

  test "Entity is specialized for starting the reference" do
    assert entity.is_a?(Update::Entity::StartReference)
  end

  test "Related entity ID is set" do
    assert entity.related_entity_id == Controls::ID::RelatedEntity.example
  end

  test "Destination stream name is set" do
    assert entity.destination_stream_name == Controls::StreamName::RelatedEntity.example
  end

  test "Control" do
    assert entity == Controls::Update::Entity::StartReference::Initiated.example
  end
end
