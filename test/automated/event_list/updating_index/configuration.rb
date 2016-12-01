require_relative '../../automated_init'

context "Updating index after event is added command is configured" do
  added = Controls::EventList::Messages::Added.example
  event_data = Controls::EventData::EventList.example

  update_index = EventList::UpdateIndex.build added, event_data

  test "Category is set" do
    assert update_index.category == Controls::StreamName::Category.example
  end

  test "Event list positiont is set" do
    assert update_index.event_list_position == Controls::Position::EventList.example
  end
end