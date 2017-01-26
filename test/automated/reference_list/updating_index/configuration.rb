require_relative '../../automated_init'

context "Updating index after reference is added command is configured" do
  added = Controls::ReferenceList::Messages::Added.example
  event_data = Controls::EventData::ReferenceList.example

  context do
    update_index = ReferenceList::UpdateIndex.build added, event_data

    test "Category is set" do
      assert update_index.category == Controls::StreamName::Category.example
    end

    test "Reference list position is set" do
      assert update_index.reference_list_position == Controls::Position::ReferenceList.example
    end
  end

  context "Session is specified" do
    session = EventSource::EventStore::HTTP::Session.build

    update_index = ReferenceList::UpdateIndex.build added, event_data, session: session

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
