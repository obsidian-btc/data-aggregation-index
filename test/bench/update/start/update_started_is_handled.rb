require_relative '../../bench_init'

context "Handler handles update started event, records started in update stream" do
  update_started = Controls::Messages::UpdateStarted.example(
    event_list_position: true,
    reference_list_position: true
  )
  category = Controls::StreamName::Category.example
  update = Controls::Update::Entity::Initiated.example

  start_update = Update::Start.new(update_started, category)
  start_update.update_store.add update.update_id, update, 1
  start_update.clock.now = Controls::Time::Raw.example

  start_update.()

  test "Started event is written to update stream" do
    started = Controls::Update::Messages::Started.example(
      event_list_position: true,
      reference_list_position: true
    )
    update_stream_name = Controls::StreamName::Update.example

    assert start_update.writer do
      written? do |msg, stream_name|
        msg == started && stream_name == update_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert start_update.writer do
      written? do |_, _, expected_version|
        expected_version == 1
      end
    end
  end
end
