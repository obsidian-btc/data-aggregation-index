require_relative '../../automated_init'

context "Handler handles update started event, update is already started" do
  update_started = Controls::Messages::UpdateStarted.example
  category = Controls::StreamName::Category.example
  update = Controls::Update::Entity::Finished.example

  start_update = Update::Start.new(update_started, category)
  start_update.update_store.add update.update_id, update

  start_update.()

  test "Nothing is written" do
    refute start_update.write do
      written?
    end
  end
end
