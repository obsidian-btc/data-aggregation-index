require_relative '../bench_init'

context "Reference is already added to index" do
  entity_id = Controls::ID::Entity.example

  category = Controls::StreamName::Category.example
  destination_stream_name = Controls::StreamName::RelatedEntity.example

  update = Controls::Update::Entity::AddReference::Initiated.example

  add_reference = AddReference.new category
  add_reference.update_store.add update.update_id, update

  add_reference.(entity_id, destination_stream_name)

  test "Nothing is written" do
    refute add_reference.writer do
      written?
    end
  end
end
