require_relative '../bench_init'

context "Reference is already added to index" do
  category = Controls::StreamName::Category.example
  destination_stream_name = Controls::StreamName::RelatedEntity.example

  entity = Controls::Update::Entity::AddReference::Initiated.example

  add_reference = AddReference.new category
  add_reference.update_store.add entity.update_id, entity

  add_reference.(destination_stream_name)

  test "Nothing is written" do
    refute add_reference.writer do
      written?
    end
  end
end
