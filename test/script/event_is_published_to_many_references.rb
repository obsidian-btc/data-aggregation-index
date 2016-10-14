require_relative './script_init'

entity_id = Identifier::UUID::Random.get

count = ENV['COUNT'].to_i
count = 100 if count.zero?

publish_event = Controls::Index::PublishEvent.build
add_reference = Controls::Index::AddReference.build

related_entity_streams = count.times.map do
  related_entity_id = Identifier::UUID::Random.get
  "someRelatedEntity-#{related_entity_id}"
end

related_entity_streams.each do |related_entity_stream_name|
  add_reference.(entity_id, related_entity_stream_name)
end

event = Controls::SourceEvent.example

publish_event.(entity_id, event)

related_entity_streams.each do |related_entity_stream_name|
  expect_message = Fixtures::ExpectMessage.build related_entity_stream_name
  expect_message.('SomeEvent')
end
