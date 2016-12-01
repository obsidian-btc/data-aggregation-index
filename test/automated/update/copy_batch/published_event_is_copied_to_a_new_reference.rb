require_relative '../../automated_init'

context "Published event is copied to a new reference" do
  related_entity_stream_name = Controls::StreamName::RelatedEntity.example
  update = Controls::Update::Entity::PublishEvent.example

  copy = Update::CopyBatch::Copy::Reference.new update
  copy.(related_entity_stream_name)

  event_data = Controls::SourceEvent::EventData::Write.example

  test "Source event is copied to related entity stream" do
    assert copy.copy_message do
      copied_message? do |msg, stream_name|
        msg == event_data && stream_name == related_entity_stream_name
      end
    end
  end
end
