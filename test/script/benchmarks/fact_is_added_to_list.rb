require_relative './benchmark_init'

update_stream_name = Controls::StreamName::Update.example random: true

ENV['FACT_TYPE'] ||= 'reference'

if ENV['FACT_TYPE'] == 'reference'
  fact_message_class = 'AddReferenceInitiated'
else
  fact_message_class = 'PublishEventInitiated'
end

writer = EventStore::Messaging::Writer.build

Defaults.iteration_count.times do |index|
  list_position = index - 5
  list_position = false if list_position < 0

  event = Controls::Update::Messages.const_get(fact_message_class).example(
    index,
    list_position: list_position
  )

  writer.write event, update_stream_name
end

measure update_stream_name, Controls::Index::Dispatchers::Update
