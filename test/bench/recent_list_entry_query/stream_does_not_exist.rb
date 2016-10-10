require_relative '../bench_init'

context "Recent list entry query, stream does not exist" do
  update_id = Controls::RecentListEntryQuery::UpdateID.example
  projection_class = Controls::RecentListEntryQuery::Projection::Example
  stream_name = Controls::StreamName.example

  context do
    query = RecentListEntryQuery.new projection_class

    block_executed = false
    result = query.(stream_name, update_id) do
      block_executed = true
    end

    test "Block is not executed" do
      refute block_executed
    end

    test "No stream is returned" do
      assert result == :no_stream
    end
  end

  context "Starting position is specified" do
    starting_position = 11
    query = RecentListEntryQuery.new projection_class

    result = query.(stream_name, update_id, starting_position)

    test "No stream is returned" do
      assert result == :no_stream
    end
  end
end
