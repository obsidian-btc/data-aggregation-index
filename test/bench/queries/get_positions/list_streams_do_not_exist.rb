require_relative '../../bench_init'

context "Get positions from last index stream message, list streams do not exist" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example random: true

  Controls::Index::Write.(
    0,
    event_list_position: false,
    reference_list_position: false,
    category: category
  )

  get_positions = Queries::GetPositions.new

  index_pos, event_pos, reference_pos = get_positions.(entity_id, category)

  test "Index stream position is returned" do
    assert index_pos == 0
  end

  test "Event stream position indicates the event stream does not exist" do
    assert event_pos == :no_stream
  end

  test "Reference stream position indicates the event stream does not exist" do
    assert reference_pos == :no_stream
  end
end
