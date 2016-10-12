module DataAggregation::Index
  module Update
    class Entity
      include Schema::DataStructure

      attribute :entity_id
      attribute :batch_position, Integer
      attribute :copy_position, Integer

      attr_accessor :completed
      attr_accessor :started

      def completed?
        completed ? true : false
      end

      def started?
        started ? true : false
      end

      def record_completed
        self.completed = true
      end

      def finished?
        if not started?
          false
        elsif data_stream_position.nil?
          true
        else
          data_stream_position == copy_position
        end
      end

      abstract :record_started
      abstract :data_stream_position
      abstract :update_id

      module PublishEvent
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :event_id, String
            attribute :event_data_text, String
            attribute :reference_list_position, Integer
          end
        end

        def data_stream_position
          reference_list_position
        end

        def update_id
          event_id
        end

        def record_started(started)
          self.reference_list_position = started.reference_list_position
          self.started = true
        end
      end

      module AddReference
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :related_entity_id, String
            attribute :related_entity_category, String
            attribute :event_list_position, Integer
          end
        end

        def data_stream_position
          event_list_position
        end

        def update_id
          related_entity_id
        end

        def record_started(started)
          self.event_list_position = started.event_list_position
          self.started = true
        end

        def related_entity_stream_name
          StreamName.stream_name related_entity_id, related_entity_category
        end
      end
    end
  end
end
