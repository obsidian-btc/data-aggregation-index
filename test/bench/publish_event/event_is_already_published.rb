require_relative '../bench_init'

context "Event is already being published to index" do
  entity_id = Controls::ID::Entity.example

  source_event = Controls::SourceEvent.example
  category = Controls::StreamName::Category.example

  entity = Controls::Update::Entity::PublishEvent::Initiated.example

  publish_event = PublishEvent.new category
  publish_event.clock.now = Controls::Time::Raw.example
  publish_event.update_store.add entity.update_id, entity

  publish_event.(entity_id, source_event)

  test "Nothing is written" do
    refute publish_event.writer do
      written?
    end
  end
end
