require_relative '../automated_init'

context "Reference list stream name" do
  category = Controls::StreamName::Category.example

  object = Controls::StreamName::Example.new

  context "Individual stream" do
    entity_id = Controls::ID::Entity.example

    stream_name = object.reference_list_stream_name entity_id, category

    test do
      assert stream_name == Controls::StreamName::ReferenceList.example
    end
  end

  context "Category stream" do
    stream_name = object.reference_list_category_stream_name category

    test do
      assert stream_name == Controls::StreamName::ReferenceList::Category::EventStore.example
    end
  end
end
