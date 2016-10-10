require_relative '../bench_init'

context "Get positions from last index stream message, reference list stream does not exist" do
  entity_id = Controls::ID::Entity.example
  category = Controls::StreamName::Category.example random: true
  index_stream_name = DataAggregation::Index::StreamName.index_stream_name entity_id, category

  update_initiated = Controls::Messages::UpdateInitiated::PublishEvent.example
  writer = EventStore::Messaging::Writer.build
  writer.write_initial update_initiated, index_stream_name

  get_positions = GetPositions.new

  index_pos, event_pos, reference_pos = get_positions.(entity_id, category)

  test "Index stream position is returned" do
    assert index_pos == 0
  end

  test "Event stream position is returned" do
    assert event_pos == 0
  end

  test "Reference stream position indicates the event stream does not exist" do
    assert reference_pos == :no_stream
  end
end
