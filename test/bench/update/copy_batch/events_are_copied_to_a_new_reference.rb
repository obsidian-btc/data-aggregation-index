require_relative '../../bench_init'

context "All existing events are copied to a new reference" do
  event_data_list = Controls::Update::Batch::EventData::Text.example
  update = Controls::Update::Entity::AddReference.example

  copy = Update::CopyBatch::Copy::PublishedEvents.new update, event_data_list
  copy.()

  related_entity_stream_name = Controls::StreamName::RelatedEntity.example

  control_batch = Controls::Update::Batch::EventData.example
  control_batch.each_with_index do |event_data, index|
    test "Stream #{related_entity_stream_name.inspect} receives event ##{index + 1}" do
      assert copy.copy_message do
        copied_message? do |msg, stream_name|
          msg == event_data && stream_name == related_entity_stream_name
        end
      end
    end
  end
end
