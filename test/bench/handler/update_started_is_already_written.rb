require_relative '../bench_init'

context "Handler handles update started event, update is already started" do
  update_started = Controls::Messages::UpdateStarted.example(
    event_list_position: true,
    reference_list_position: true
  )
  event_data = Controls::EventData::Index.example
  update = Controls::Update::Entity::Started.example

  handler = Handler.new
  handler.update_store.add update.update_id, update, 1

  handler.handle update_started, event_data

  test "Nothing is written" do
    refute handler.writer do
      written?
    end
  end
end
