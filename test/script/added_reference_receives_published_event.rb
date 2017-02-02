require_relative './script_init'

entity_id = Identifier::UUID::Random.get
related_entity_id = Identifier::UUID::Random.get
related_entity_stream_name = "someRelatedEntity-#{related_entity_id}"

event = Controls::SourceEvent.example entity_id: entity_id

publish_event = Controls::Index::PublishEvent.build
publish_event.(entity_id, event)

add_reference = Controls::Index::AddReference.build
add_reference.(entity_id, related_entity_stream_name)

expect_message = Fixtures::ExpectMessage.build related_entity_stream_name

expect_message.('SomeEvent')
