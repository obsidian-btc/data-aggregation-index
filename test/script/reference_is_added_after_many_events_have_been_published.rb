require_relative './script_init'

ENV['ENTITY_ID'] ||= Identifier::UUID::Random.get
entity_id = ENV['ENTITY_ID']

related_entity_id = Identifier::UUID::Random.get
related_entity_stream_name = "someRelatedEntity-#{related_entity_id}"
source_stream_name = "someEntity-#{entity_id}"

count = ENV['COUNT'].to_i
count = 100 if count.zero?

publish_event = Controls::Index::PublishEvent.build
add_reference = Controls::Index::AddReference.build

module Counter
  class Message
    include EventStore::Messaging::Message

    attribute :index, Integer
  end

  class Handler
    include Telemetry::Logger::Dependency
    include EventStore::Messaging::Handler

    dependency :publish_event, Controls::Index::PublishEvent

    def configure
      Controls::Index::PublishEvent.configure self
    end

    handle Message do |msg, event_data|
      publish_event.(entity_id, msg)
    end

    def entity_id
      ENV.fetch 'ENTITY_ID'
    end
  end

  class Dispatcher
    include EventStore::Messaging::Dispatcher
    handler Handler
  end
end

writer = EventStore::Messaging::Writer.build

count.times.map do |index|
  counter = Counter::Message.build
  counter.index = index

  counter.metadata.source_event_uri = "/streams/#{source_stream_name}/#{index}"

  expected_version = index.zero? ? :no_stream : index.pred
  writer.write counter, source_stream_name, expected_version: expected_version
end

reader = EventStore::Messaging::Reader.build source_stream_name, Counter::Dispatcher.build
reader.start

sleep 1

add_reference.(entity_id, related_entity_stream_name)

expect_message = Fixtures::ExpectMessage.build related_entity_stream_name
count.times.each do |index|
  expect_message.('Message') do |data|
    data[:index] == index
  end
end
