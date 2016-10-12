module DataAggregation::Index
  module Update
    class Entity
      module PublishEvent
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :event_id, String

            attribute :event_data_text, String
            attribute :reference_list_position, Integer

            alias_method :data_stream_position, :reference_list_position
            alias_method :update_id, :event_id
          end
        end

        def record_started(started)
          self.reference_list_position = started.reference_list_position
          self.started = true
        end
      end
    end
  end
end