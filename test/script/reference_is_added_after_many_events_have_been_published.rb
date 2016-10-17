require_relative './script_init'

ENV['ENTITY_ID'] ||= Identifier::UUID::Random.get
entity_id = ENV['ENTITY_ID']

related_entity_id = Identifier::UUID::Random.get
related_entity_stream_name = "someRelatedEntity-#{related_entity_id}"
source_stream_name = "someEntity-#{entity_id}"

publish_event = Controls::Index::PublishEvent.build
add_reference = Controls::Index::AddReference.build

class Counter
  include EventStore::Messaging::Message
  attribute :index, Integer
end

Defaults.iteration_count.times.map do |index|
  counter = Counter.build :index => index
  counter.metadata.source_event_uri = "/streams/#{source_stream_name}/#{index}"
  publish_event.(entity_id, counter)
end

add_reference.(entity_id, related_entity_stream_name)

expect_message = Fixtures::ExpectMessage.build related_entity_stream_name
count.times.each do |index|
  expect_message.('Counter') do |data|
    data[:index] == index
  end
end
