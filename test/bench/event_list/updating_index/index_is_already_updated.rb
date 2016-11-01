require_relative '../../bench_init'

context "Updating index upon an event being added, index is already updated" do
  event_list_version = Controls::Position::EventList.example
  event_added = Controls::EventList::Messages::Added.example event_list_version
  category = Controls::StreamName::Category.example
  index_stream_name = Controls::StreamName::Index.example

  update_index = EventList::UpdateIndex.new event_added, category, event_list_version
  update_index.get_positions.set(
    index_stream_name, 
    Controls::Position::Index.example,
    event_list_version,
    nil
  )
  update_index.()

  test "Nothing is written" do
    refute update_index.writer do
      written?
    end
  end
end
