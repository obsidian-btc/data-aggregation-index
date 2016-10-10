require_relative '../bench_init'

context "Event is already being published to index" do
  source_event = Controls::SourceEvent.example
  category = Controls::StreamName::Category.example

  entity = Controls::Update::Entity::PublishEvent::Initiated.example
  event_id = entity.event_id

  publish_event = PublishEvent.new category
  publish_event.clock.now = Controls::Time::Raw.example
  publish_event.update_store.add event_id, entity

  event_written = publish_event.(source_event, entity.event_id)

  test "Nothing is written" do
    refute publish_event.writer do
      written?
    end
  end
end
