require_relative '../../bench_init'

context "Recent fact query, message is not found" do
  update_id = Controls::ID::Update.example 1
  projection_class = Controls::FactList::Projection::Example
  stream_name = Controls::FactList::Write.(0)

  query = Queries::GetRecentFact.new projection_class

  block_executed = false
  result = query.(stream_name, update_id) do
    block_executed = true
  end

  test "Block is not executed" do
    refute block_executed
  end

  test "Stream version is returned" do
    assert result == 0
  end
end