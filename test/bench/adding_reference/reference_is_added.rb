require_relative '../bench_init'

context "Adding reference to an event list" do
  category = Controls::StreamName::Category.example
  related_entity_id = Controls::ID::RelatedEntity.example
  add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example
  reference_list_stream_name = Controls::StreamName::ReferenceList.example

  add = ReferenceList::Add.new add_reference_initiated, category
  add.clock.now = Controls::Time::Raw.example
  add.recent_reference_added_query.set reference_list_stream_name, version: 1

  add.()

  test "Reference added message is written to reference list stream" do
    reference_added = Controls::Messages::ReferenceAdded.example

    assert add.writer do
      written? do |msg, stream_name|
        msg == reference_added && stream_name == reference_list_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert add.writer do
      written? do |_, _, expected_version|
        expected_version == 1
      end
    end
  end
end