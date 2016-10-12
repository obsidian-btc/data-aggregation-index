module DataAggregation::Index
  module Update
    class Entity
      include Schema::DataStructure

      attribute :entity_id
      attribute :batch_position, Integer
      attribute :copy_position, Integer
      attribute :list_position, Integer

      attr_accessor :completed
      attr_accessor :started

      def completed?
        completed ? true : false
      end

      def finished?
        if not started?
          false
        elsif list_position.nil?
          true
        else
          list_position == copy_position
        end
      end

      def record_completed
        self.completed = true
      end

      def started?
        started ? true : false
      end

      abstract :record_started
      abstract :update_id
    end
  end
end
