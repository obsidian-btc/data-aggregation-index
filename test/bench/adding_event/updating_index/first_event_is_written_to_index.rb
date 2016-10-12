require_relative '../../bench_init'

context "Updating index upon an event being added, first event is written" do
  event_list_version = Controls::Position::EventList.example
  event_added = Controls::EventList::Messages::Added.example event_list_version
  category = Controls::StreamName::Category.example
  index_stream_name = Controls::StreamName::Index.example

  update_index = EventList::UpdateIndex.new event_added, category

  update_started = update_index.()

  test "Event list position is set to zero" do
    assert update_started.event_list_position == 0
  end
end
