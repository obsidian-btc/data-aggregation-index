require_relative '../automated_init'

context "Reference is added to index" do
  entity_id = Controls::ID::Entity.example

  category = Controls::StreamName::Category.example
  related_entity_stream_name = Controls::StreamName::RelatedEntity.example
  index_stream_name = Controls::StreamName::Index.example

  reference_list_position = Controls::Position::ReferenceList.example

  add_reference = AddReference.new category
  add_reference.get_positions.set index_stream_name, 0, 0, reference_list_position

  add_reference.(entity_id, related_entity_stream_name)

  test "AddReference initiated message is written to update stream" do
    add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example
    update_stream_name = Controls::StreamName::Update::AddReference.example

    assert add_reference.write do
      written? do |msg, stream_name|
        msg == add_reference_initiated && stream_name == update_stream_name
      end
    end
  end
end
