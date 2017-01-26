require_relative './script_init'

entity_id = Identifier::UUID::Random.get

event = Controls::SourceEvent.example metadata: false

entity_stream_name = Controls::StreamName::Entity.example stream_id: entity_id
write = Messaging::EventStore::Write.build
write.(event, entity_stream_name)

read_event = nil

reader = EventStore::Client::HTTP::Reader.build entity_stream_name
reader.each do |event_data|
  read_event = EventStore::Messaging::Message::Import::EventData.(
    event_data,
    Controls::SourceEvent::SomeEvent
  )
end

publish_event = Controls::Index::PublishEvent.build
publish_event.(entity_id, read_event)

event_id = Controls::ID::SourceEvent.example stream_id: entity_id
update_stream_name = StreamName.update_stream_name event_id, Controls::Index.category

expect_message = Fixtures::ExpectMessage.build update_stream_name

expect_message.('PublishEventInitiated')
expect_message.('Started')
expect_message.('Completed')
