require_relative '../../automated_init'

context "Get next update batch, query substitute" do
  entity_id = Controls::ID::Entity.example

  context "No results have been added" do
    query = SubstAttr::Substitute.build Update::GetNextBatch::Query

    results = query.(entity_id, 0, 1)

    test "Empty list is returned" do
      assert results == []
    end
  end

  context "Results have been added" do
    query = SubstAttr::Substitute.build Update::GetNextBatch::Query
    query.add entity_id, %w(result-1 result-2 result-3), 11

    context "Query is within range of results" do
      results = query.(entity_id, 11, 12)

      test "Results are returned" do
        assert results == %w(result-1 result-2)
      end
    end

    context "Query is outside range of results" do
      results = query.(entity_id, 0, 1)

      test "Empty list is returned" do
        assert results == []
      end
    end
  end
end
