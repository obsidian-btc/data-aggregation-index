require_relative '../bench_init'

context "Handler handles update started event, records started in update stream" do
  update_started = Controls::Messages::UpdateStarted.example(
    event_list_position: true,
    reference_list_position: true
  )
  event_data = Controls::EventData::Index.example
  update = Controls::Update::Entity::Initiated.example

  handler = Handler.new
  handler.update_store.add update.update_id, update, 1
  handler.clock.now = Controls::Time::Raw.example

  handler.handle update_started, event_data

  test "Started event is written to update stream" do
    started = Controls::Update::Messages::Started.example(
      event_list_position: true,
      reference_list_position: true
    )
    update_stream_name = Controls::StreamName::Update.example

    assert handler.writer do
      written? do |msg, stream_name|
        msg == started && stream_name == update_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert handler.writer do
      written? do |_, _, expected_version|
        expected_version == 1
      end
    end
  end
end
