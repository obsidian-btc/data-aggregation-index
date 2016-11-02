require_relative './script_init'

entity_id = Identifier::UUID::Random.get

event = Controls::SourceEvent.example entity_id: entity_id

publish_event = Controls::Index::PublishEvent.build
publish_event.(entity_id, event)

event_id = Controls::ID::SourceEvent.example stream_id: entity_id
update_stream_name = StreamName.update_stream_name event_id, Controls::Index.category

expect_message = Fixtures::ExpectMessage.build update_stream_name

expect_message.('PublishEventInitiated')
expect_message.('Started')
expect_message.('Completed')
