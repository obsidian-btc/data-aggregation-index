module DataAggregation::Index
  module Update
    module Entity
      def self.included(cls)
        cls.class_exec do
          include Schema::DataStructure

          attribute :batch_position, Integer, default: 0
          attribute :copy_position, Integer, default: 0

          abstract :started?
        end
      end

      class PublishEvent
        include Entity

        attribute :event_id, String

        attribute :event_data_text, String
        attribute :reference_stream_position, Integer

        def started?
          reference_stream_position ? true : false
        end
      end

      class StartReference
        include Entity

        attribute :related_entity_id, String

        attribute :destination_stream_name, String
        attribute :event_stream_position, Integer

        def started?
          event_stream_position ? true : false
        end
      end
    end
  end
end
