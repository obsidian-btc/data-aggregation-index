require_relative '../../automated_init'

context "Adding reference to a reference list" do
  category = Controls::StreamName::Category.example
  add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example

  add = ReferenceList::Add.new add_reference_initiated, category
  add.clock.now = Controls::Time::Raw.example

  add.()

  test "Reference added message is written to reference list stream" do
    reference_added = Controls::ReferenceList::Messages::Added.example
    reference_list_stream_name = Controls::StreamName::ReferenceList.example

    assert add.writer do
      written? do |msg, stream_name|
        msg == reference_added && stream_name == reference_list_stream_name
      end
    end
  end
end
