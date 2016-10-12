module DataAggregation::Index
  module Queries
    class GetPositions
      include Telemetry::Logger::Dependency

      include StreamName

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
        reader = EventStore::Client::HTTP::Reader.build stream_name, direction: :backward, slice_size: 1

        reader.each do |event_data|
          message = build_message event_data

          index_pos = event_data.number
          event_list_pos = message.event_list_position if message.event_list_position
          reference_list_pos = message.reference_list_position if message.reference_list_position

          block.(index_pos, event_list_pos, reference_list_pos)

          break
        end
      end

      def build_message(event_data)
        EventStore::Messaging::Message::Import::EventData.(
          event_data,
          Messages::UpdateStarted
        )
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
