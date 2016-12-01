require_relative '../../automated_init'

context "Get positions from last index stream message, substitute" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example

  context "Substitute has been programmed" do
    stream_name = Controls::StreamName::Index.example

    substitute = SubstAttr::Substitute.build Queries::GetPositions
    substitute.set stream_name, 1, 2, 3

    index_pos, event_pos, reference_pos = substitute.(entity_id, category)

    test "Index position is returned" do
      assert index_pos == 1
    end

    test "Event position is returned" do
      assert event_pos == 2
    end

    test "Reference position is returned" do
      assert reference_pos == 3
    end
  end

  context "Substitute has not been programmed" do
    substitute = SubstAttr::Substitute.build Queries::GetPositions

    index_pos, event_pos, reference_pos = substitute.(entity_id, category)

    test "Index position is no stream" do
      assert index_pos == :no_stream
    end

    test "Event position is no stream" do
      assert event_pos == :no_stream
    end

    test "Reference position is no stream" do
      assert reference_pos == :no_stream
    end
  end
end
