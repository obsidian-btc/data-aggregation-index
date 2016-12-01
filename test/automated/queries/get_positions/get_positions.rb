require_relative '../../automated_init'

context "Get positions from last index stream message" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example random: true

  Controls::Index::Write.(0, category: category)

  get_positions = Queries::GetPositions.new

  index_pos, event_pos, reference_pos = get_positions.(entity_id, category)

  test "Index stream position is returned" do
    assert index_pos == 0
  end

  test "Event stream position is returned" do
    assert event_pos == Controls::Position::EventList.example
  end

  test "Reference stream position is returned" do
    assert reference_pos == Controls::Position::ReferenceList.example
  end
end
