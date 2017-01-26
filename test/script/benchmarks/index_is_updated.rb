require_relative './benchmark_init'

list_stream_name = Controls::StreamName::Update.example random: true

write = Messaging::EventStore::Write.build

Defaults.iteration_count.times do |index|
  event = Controls::EventList::Messages::Added.example index

  write.(event, list_stream_name)
end

measure list_stream_name, Controls::Index::Dispatchers::EventList
