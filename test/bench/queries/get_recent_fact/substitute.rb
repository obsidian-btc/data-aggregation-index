require_relative '../../bench_init'

context "Recent fact query substitute" do
  update_id = Controls::ID::Update.example 1
  stream_name = Controls::FactList::Write.(0)

  context "Stream is not configured" do
    substitute = SubstAttr::Substitute.build Queries::GetRecentFact

    block_executed = false
    result = substitute.(stream_name, update_id) { block_executed = true }

    test "No stream is returned" do
      assert result == :no_stream
    end

    test "Block is not executed" do
      refute block_executed
    end
  end

  context "Starting position precedes specified position" do
    substitute = SubstAttr::Substitute.build Queries::GetRecentFact
    substitute.set stream_name, update_id, version: 1

    block_executed = false
    result = substitute.(stream_name, update_id, 0) { block_executed = true }

    test "Specified position is returned" do
      assert result == 1
    end

    test "Block is executed" do
      assert block_executed
    end
  end

  context "Starting position equals specified position" do
    substitute = SubstAttr::Substitute.build Queries::GetRecentFact
    substitute.set stream_name, update_id, version: 0

    block_executed = false
    result = substitute.(stream_name, update_id, 0) { block_executed = true }

    test "Block is executed" do
      assert block_executed
    end
  end

  context "Specifiec position precedes starting position" do
    substitute = SubstAttr::Substitute.build Queries::GetRecentFact
    substitute.set stream_name, update_id, version: 0

    block_executed = false
    result = substitute.(stream_name, update_id, 1) { block_executed = true }

    test "Specified position is returned" do
      assert result == 0
    end

    test "Block is not executed" do
      refute block_executed
    end
  end
end
