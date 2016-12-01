require_relative '../../automated_init'

context "Get next batch of published events query" do
  entity_id = Controls::ID::Entity.example
  stream_name = Controls::EventList::Write.(2)
  category = StreamName.get_category stream_name

  context "List is empty" do
    query = Update::GetNextBatch::Query::PublishedEvents.new
    query.category = Controls::StreamName::Category.example

    results = query.(entity_id, 0, 1)

    test "No results are returned" do
      assert results == []
    end
  end

  context "List contains published_events" do
    query = Update::GetNextBatch::Query::PublishedEvents.new
    query.category = category

    results = query.(entity_id, 0, 2)

    test "Results are returned" do
      assert results == [
        Controls::SourceEvent::EventData::Text.example(0),
        Controls::SourceEvent::EventData::Text.example(1),
        Controls::SourceEvent::EventData::Text.example(2)
      ]
    end
  end

  context "Ending position exceeds the final published event" do
    query = Update::GetNextBatch::Query::PublishedEvents.new
    query.category = category

    results = query.(entity_id, 0, 1)

    test "Results after ending position are not returned" do
      assert results == [
        Controls::SourceEvent::EventData::Text.example(0),
        Controls::SourceEvent::EventData::Text.example(1),
      ]
    end
  end
end

