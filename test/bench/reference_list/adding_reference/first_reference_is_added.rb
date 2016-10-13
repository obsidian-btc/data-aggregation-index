require_relative '../../bench_init'

context "Adding the first reference to a reference list" do
  category = Controls::StreamName::Category.example
  add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example 0

  add = ReferenceList::Add.new add_reference_initiated, category
  add.clock.now = Controls::Time::Raw.example

  add.()

  test "Reference added message is written to reference list stream" do
    reference_added = Controls::ReferenceList::Messages::Added.example 0
    reference_list_stream_name = Controls::StreamName::ReferenceList.example

    assert add.writer do
      written? do |msg, stream_name|
        msg == reference_added && stream_name == reference_list_stream_name
      end
    end
  end

  test "Reference added message is expected to initiate stream" do
    assert add.writer do
      written? do |_, _, expected_version|
        expected_version == :no_stream
      end
    end
  end
end
