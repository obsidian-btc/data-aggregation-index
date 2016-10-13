require_relative '../../bench_init'

context "Source event is copied to a new reference" do
  event_data_text = Controls::SourceEvent::EventData::Text.example
  update = Controls::Update::Entity::AddReference.example

  copy = Update::CopyBatch::Copy::PublishedEvent.new update
  copy.(event_data_text)

  related_entity_stream_name = Controls::StreamName::RelatedEntity.example

  test "Event is copied related entity stream name" do
    event_data = Controls::SourceEvent::EventData::Write.example

    assert copy.copy_message do
      copied_message? do |msg, stream_name|
        msg == event_data && stream_name == related_entity_stream_name
      end
    end
  end
end
