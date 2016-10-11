require_relative '../../bench_init'

context "Add reference update, initiated event is projected onto entity" do
  entity = Update::Entity.new

  projection = Update::Projection.new entity

  initiated = Controls::Update::Messages::AddReferenceInitiated.example
  projection.apply initiated

  test "Entity is specialized for starting the reference" do
    assert entity.is_a?(Update::Entity::AddReference)
  end

  test "Entity ID is set" do
    assert entity.entity_id == Controls::ID::Entity.example
  end

  test "Related entity ID is set" do
    assert entity.related_entity_id == Controls::ID::RelatedEntity.example
  end

  test "Destination stream name is set" do
    assert entity.destination_stream_name == Controls::StreamName::RelatedEntity.example
  end

  test "Control" do
    assert entity == Controls::Update::Entity::AddReference::Initiated.example
  end
end
