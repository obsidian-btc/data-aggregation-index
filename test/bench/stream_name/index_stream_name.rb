require_relative '../bench_init'

context "Index stream name" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example

  object = Controls::StreamName::Example.new

  stream_name = object.index_stream_name entity_id, category

  test do
    assert stream_name == Controls::StreamName::Index.example
  end
end
