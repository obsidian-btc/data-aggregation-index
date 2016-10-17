require_relative './benchmark_init'

list_stream_name = Controls::StreamName::Update.example random: true

writer = EventStore::Messaging::Writer.build

Defaults.iteration_count.times do |index|
  event = Controls::EventList::Messages::Added.example index

  writer.write event, list_stream_name
end

measure list_stream_name, Controls::Index::Dispatchers::EventList
