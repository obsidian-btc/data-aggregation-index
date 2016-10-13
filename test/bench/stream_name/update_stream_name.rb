require_relative '../bench_init'

context "Update stream name" do
  category = Controls::StreamName::Category.example

  object = Controls::StreamName::Example.new

  context "Individual stream" do
    update_id = Controls::ID::Update.example

    stream_name = object.update_stream_name update_id, category

    test do
      assert stream_name == Controls::StreamName::Update.example
    end
  end

  context "Category stream" do
    stream_name = object.update_category_stream_name category

    test do
      assert stream_name == Controls::StreamName::Update::Category::EventStore.example
    end
  end
end
