require_relative '../../bench_init'

context "Adding reference to a reference list" do
  category = Controls::StreamName::Category.example
  add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example
  reference_list_stream_name = Controls::StreamName::ReferenceList.example
  reference_list_version = Controls::Position::ReferenceList.example

  add = ReferenceList::Add.new add_reference_initiated, category
  add.clock.now = Controls::Time::Raw.example
  add.get_recent_reference.set(
    reference_list_stream_name,
    version: reference_list_version
  )

  add.()

  test "Reference added message is written to reference list stream" do
    reference_added = Controls::ReferenceList::Messages::Added.example

    assert add.writer do
      written? do |msg, stream_name|
        msg == reference_added && stream_name == reference_list_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert add.writer do
      written? do |_, _, expected_version|
        expected_version == reference_list_version
      end
    end
  end
end
