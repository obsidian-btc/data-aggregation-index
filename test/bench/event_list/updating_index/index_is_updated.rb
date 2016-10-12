require_relative '../../bench_init'

context "Updating index upon an event being added" do
  event_list_version = Controls::Position::EventList.example
  event_added = Controls::EventList::Messages::Added.example event_list_version
  category = Controls::StreamName::Category.example
  index_stream_name = Controls::StreamName::Index.example

  update_index = EventList::UpdateIndex.new event_added, category
  update_index.clock.now = Controls::Time::Raw.example
  update_index.get_positions.set(
    index_stream_name, 
    Controls::Position::Index.example,
    Controls::Position::EventList::Previous.example,
    nil
  )
  update_index.()

  test "Update started is written to index stream" do
    update_started = Controls::Messages::UpdateStarted::PublishEvent.example event_list_version
    index_stream_name = Controls::StreamName::Index.example

    assert update_index.writer do
      written? do |msg, stream_name|
        msg == update_started && stream_name == index_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert update_index.writer do
      written? do |_, _, expected_version|
        expected_version == Controls::Position::Index.example
      end
    end
  end
end
