require_relative '../../automated_init'

context "Updating index upon an event being added, first event is written" do
  event_added = Controls::EventList::Messages::Added.example
  category = Controls::StreamName::Category.example

  update_index = EventList::UpdateIndex.new event_added, category, 0

  update_started = update_index.()

  test "Event list position is set to zero" do
    assert update_started.event_list_position == 0
  end
end
