require_relative './script_init'

entity_id = Identifier::UUID::Random.get
related_entity_id = Identifier::UUID::Random.get
related_entity_stream_name = "someRelatedEntity-#{related_entity_id}"

event = Controls::SourceEvent.example

add_reference = Controls::Index::AddReference.build
add_reference.(entity_id, related_entity_stream_name)

update_stream_name = StreamName.update_stream_name related_entity_id, Controls::Index.category

expect_message = Fixtures::ExpectMessage.build update_stream_name

expect_message.('AddReferenceInitiated')
expect_message.('Started')
expect_message.('Completed')
