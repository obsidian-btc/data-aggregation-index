require_relative '../bench_init'

context "Reference list stream name" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example

  object = Controls::StreamName::Example.new

  stream_name = object.reference_list_stream_name entity_id, category

  test do
    assert stream_name == Controls::StreamName::ReferenceList.example
  end
end
