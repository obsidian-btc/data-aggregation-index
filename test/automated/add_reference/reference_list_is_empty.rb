require_relative '../automated_init'

context "Reference is added to index, reference list is empty" do
  entity_id = Controls::ID::Entity.example

  category = Controls::StreamName::Category.example
  related_entity_stream_name = Controls::StreamName::RelatedEntity.example

  add_reference = AddReference.new category
  add_reference.(entity_id, related_entity_stream_name)

  test "AddReference initiated message is written to update stream" do
    add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example list_position: false
    update_stream_name = Controls::StreamName::Update::AddReference.example

    assert add_reference.write do
      written? do |msg, stream_name|
        msg == add_reference_initiated && stream_name == update_stream_name
      end
    end
  end
end
