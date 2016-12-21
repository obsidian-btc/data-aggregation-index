require_relative '../../automated_init'

context "Updating index after event is added command is configured" do
  added = Controls::EventList::Messages::Added.example
  event_data = Controls::EventData::EventList.example

  context do
    update_index = EventList::UpdateIndex.build added, event_data

    test "Category is set" do
      assert update_index.category == Controls::StreamName::Category.example
    end

    test "Event list positiont is set" do
      assert update_index.event_list_position == Controls::Position::EventList.example
    end
  end

  context "Session is specified" do
    session = Object.new

    update_index = EventList::UpdateIndex.build added, event_data, session: session

    test "Session is passed to writer" do
      assert update_index.writer do
        session? session
      end
    end

    test "Session is passed to get positions query" do
      assert update_index.get_positions.session == session
    end
  end
end
