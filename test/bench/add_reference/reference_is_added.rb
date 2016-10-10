require_relative '../bench_init'

context "Reference is added to index" do
  category = Controls::StreamName::Category.example
  destination_stream_name = Controls::StreamName::RelatedEntity.example

  add_reference = AddReference.new category

  add_reference.(destination_stream_name)

  test "AddReference initiated message is written to update stream" do
    add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example
    update_stream_name = Controls::StreamName::Update::AddReference.example

    assert add_reference.writer do
      written? do |msg, stream_name|
        msg == add_reference_initiated && stream_name == update_stream_name
      end
    end
  end
end
