module DataAggregation::Index
  module Update
    class Entity
      module AddReference
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :related_entity_id, String

            attribute :related_entity_category, String
            attribute :event_list_position, Integer

            alias_method :data_stream_position, :event_list_position
            alias_method :update_id, :related_entity_id
          end
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
