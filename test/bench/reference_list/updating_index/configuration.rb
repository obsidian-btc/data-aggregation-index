require_relative '../../bench_init'

context "Updating index after reference is added command is configured" do
  added = Controls::ReferenceList::Messages::Added.example
  event_data = Controls::EventData::ReferenceList.example

  update_index = ReferenceList::UpdateIndex.build added, event_data

  test "Category is set" do
    assert update_index.category == Controls::StreamName::Category.example
  end
end
