module DataAggregation::Index
  class AddReference
    module Substitute
      def self.build
        AddReference.new
      end

      class AddReference
        def call(entity_id, related_entity_stream_name)
          record = Record.new entity_id, related_entity_stream_name
          records << record
          record
        end

        def records
          @records ||= []
        end

        Record = Struct.new :entity_id, :related_entity_stream_name

        module Assertions
          def reference_added?(related_entity_stream_name=nil, &block)
            if related_entity_stream_name.nil?
              block ||= proc { true }
            else
              block ||= proc { |_, stream| stream == related_entity_stream_name }
            end

            records.any? do |record|
              block.(record.entity_id, record.related_entity_stream_name)
            end
          end
        end
      end
    end
  end
end
