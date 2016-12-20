require_relative '../../automated_init'

context "Get next batch of references query" do
  entity_id = Controls::ID::Entity.example
  stream_name = Controls::ReferenceList::Write.(2)
  category = StreamName.get_category stream_name

  context "List is empty" do
    query = Update::GetNextBatch::Query::References.new
    EventStore::Client::HTTP::Session.configure query
    query.category = Controls::StreamName::Category.example

    results = query.(entity_id, 0, 1)

    test "No results are returned" do
      assert results == []
    end
  end

  context "List contains references" do
    query = Update::GetNextBatch::Query::References.new
    EventStore::Client::HTTP::Session.configure query
    query.category = category

    results = query.(entity_id, 0, 2)

    test "Results are returned" do
      assert results == [
        Controls::StreamName::RelatedEntity.example(0),
        Controls::StreamName::RelatedEntity.example(1),
        Controls::StreamName::RelatedEntity.example(2)
      ]
    end
  end

  context "Ending position exceeds the final reference" do
    query = Update::GetNextBatch::Query::References.new
    EventStore::Client::HTTP::Session.configure query
    query.category = category

    results = query.(entity_id, 0, 1)

    test "Results after ending position are not returned" do
      assert results == [
        Controls::StreamName::RelatedEntity.example(0),
        Controls::StreamName::RelatedEntity.example(1)
      ]
    end
  end
end
