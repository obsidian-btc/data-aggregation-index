module DataAggregation::Index
  module Update
    class Entity
      module AddReference
        def self.extended(object)
          object.singleton_class.class_exec do
            attribute :related_entity_id, String

            attribute :related_entity_category, String

            alias_method :update_id, :related_entity_id
          end
        end

        def record_started(started)
          self.list_position = started.event_list_position
          self.started = true
        end

        def related_entity_stream_name
          StreamName.stream_name related_entity_id, related_entity_category
        end

        def type
          "AddReference"
        end
      end
    end
  end
end
