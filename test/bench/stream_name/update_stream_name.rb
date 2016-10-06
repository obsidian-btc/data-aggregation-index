require_relative '../bench_init'

context "Update stream name" do
  update_id = Controls::ID::Update.example
  category = Controls::StreamName::Category.example

  object = Controls::StreamName::Example.new

  stream_name = object.update_stream_name update_id, category

  test do
    assert stream_name == Controls::StreamName::Update.example
  end
end
