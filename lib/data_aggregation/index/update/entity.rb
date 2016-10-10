module DataAggregation::Index
  module Update
    class Entity
      include Schema::DataStructure

      attribute :batch_position, Integer, default: 0
      attribute :copy_position, Integer, default: 0

      def started?
        data_stream_position ? true : false
      end

      abstract :record_started
      abstract :update_id

      module PublishEvent
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :event_id, String
            attribute :event_data_text, String
            attribute :reference_stream_position, Integer
          end
        end

        def update_id
          event_id
        end

        def record_started(started)
          self.reference_stream_position = started.reference_stream_position
        end
      end

      module AddReference
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :related_entity_id, String
            attribute :destination_stream_name, String
            attribute :event_stream_position, Integer
          end
        end

        def update_id
          related_entity_id
        end

        def record_started(started)
          self.event_stream_position = started.event_stream_position
        end
      end
    end
  end
end
