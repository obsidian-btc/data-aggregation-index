require_relative '../../bench_init'

context "Published event is copied to list of references" do
  destination_stream_names = Controls::StreamName::RelatedEntity::Batch.example
  update = Controls::Update::Entity::PublishEvent::Copying.example

  copy = Update::CopyBatch::Copy::References.new update, destination_stream_names
  copy.()

  event_data = Controls::SourceEvent::EventData::Write.example

  destination_stream_names.each do |destination_stream_name|
    test "Stream #{destination_stream_name.inspect} receives event" do
      assert copy.copy_message do
        copied_message? do |msg, stream_name|
          msg == event_data && stream_name == destination_stream_name
        end
      end
    end
  end
end
