require_relative '../bench_init'

context "Recent list entry query, entry is found" do
  update_id = Controls::ID::Update.example
  projection_class = Controls::FactList::Projection::Example
  stream_name = Controls::FactList::Write.()

  query = RecentListEntryQuery.new projection_class

  block_executed = false
  result = query.(stream_name, update_id) do
    block_executed = true
  end

  test "Block is executed" do
    assert block_executed
  end

  test "Stream version is returned" do
    assert result == 0
  end
end
