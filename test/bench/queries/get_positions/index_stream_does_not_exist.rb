require_relative '../../bench_init'

context "Get positions from last index stream message, stream does not exist" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example

  get_positions = Queries::GetPositions.new

  index_pos, event_pos, reference_pos = get_positions.(entity_id, category)

  test "Index stream position indicates the index stream does not exist" do
    assert index_pos == :no_stream
  end

  test "Event stream position indicates the event stream does not exist" do
    assert event_pos == :no_stream
  end

  test "Reference stream position indicates the reference stream does not exist" do
    assert reference_pos == :no_stream
  end
end
