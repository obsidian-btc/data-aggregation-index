module DataAggregation::Index
  module Update
    class Entity
      module PublishEvent
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :event_id, String

            attribute :event_data_text, String

            alias_method :update_id, :event_id
          end
        end

        def record_started(started)
          self.list_position = started.reference_list_position
          self.started = true
        end
      end
    end
  end
end
