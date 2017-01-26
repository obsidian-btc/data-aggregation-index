module DataAggregation::Index
  module Queries
    class GetPositions
      include Log::Dependency
      include StreamName

      configure :get_positions

      dependency :session, EventSource::EventStore::HTTP::Session

      def self.build(session: nil)
        instance = new
        EventSource::EventStore::HTTP::Session.configure instance, session: session
        instance
      end

      def call(entity_id, category)
        log_attributes = "EntityID: #{entity_id}, Category: #{category}"
        logger.trace "Getting positions (#{log_attributes})"

        index_pos, event_list_pos, reference_list_pos = :no_stream, :no_stream, :no_stream

        stream_name = index_stream_name entity_id, category

        read stream_name do |_index_pos, _event_list_pos, _reference_list_pos|
          index_pos = _index_pos
          event_list_pos = _event_list_pos if _event_list_pos
          reference_list_pos = _reference_list_pos if _reference_list_pos
        end

        logger.debug "Get positions done (#{log_attributes}, IndexPosition: #{index_pos}, EventListPosition: #{event_list_pos}, ReferenceListPosition: #{reference_list_pos})"

        return index_pos, event_list_pos, reference_list_pos
      end

      def read(stream_name, &block)
        get_last = build_get_last

        event_data = get_last.(stream_name)

        return if event_data.nil?

        message = build_message event_data

        index_pos = event_data.position
        event_list_pos = message.event_list_position if message.event_list_position
        reference_list_pos = message.reference_list_position if message.reference_list_position

        block.(index_pos, event_list_pos, reference_list_pos)
      end

      def build_get_last
        EventSource::EventStore::HTTP::Get::Last.build session: session
      end

      def build_message(event_data)
        message = Messaging::Message::Import.(
          event_data,
          Messages::UpdateStarted
        )
        message.extend ::EventStore::Messaging::Message::Metadata
        message
      end

      module Substitute
        def self.build
          GetPositions.new
        end

        class GetPositions < GetPositions
          def read(stream_name, &block)
            positions = streams[stream_name]

            block.(*positions) if positions
          end

          def set(stream_name, index_pos, event_list_pos, reference_list_pos)
            streams[stream_name] = [index_pos, event_list_pos, reference_list_pos]
          end

          def streams
            @streams ||= {}
          end
        end
      end
    end
  end
end
