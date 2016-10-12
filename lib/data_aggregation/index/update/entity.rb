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

      abstract :data_stream_position

      def finished?
        if not started?
          false
        elsif data_stream_position.nil?
          true
        else
          data_stream_position == copy_position
        end
      end

      def record_completed
        self.completed = true
      end

      abstract :record_started

      def started?
        started ? true : false
      end

      abstract :update_id
    end
  end
end
