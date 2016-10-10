require_relative '../bench_init'

context "Event data text is deserialized" do
  event_data_text = Controls::SourceEvent::EventData::Text.example

  event_data = Serialize::Read.(event_data_text, :json, DataAggregation::Index::EventData)

  test "Write event data is returned" do
    assert event_data == Controls::SourceEvent::EventData::Write.example
  end
end
