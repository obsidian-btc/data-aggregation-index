module DataAggregation::Index
  class AddReference
    module Substitute
      def self.build
        AddReference.new
      end

      class AddReference
        def call(entity_id, destination_stream_name)
          record = Record.new entity_id, destination_stream_name
          records << record
          record
        end

        def records
          @records ||= []
        end

        Record = Struct.new :entity_id, :destination_stream_id

        module Assertions
          def reference_added?(destination_stream_name=nil, &block)
            if destination_stream_name.nil?
              block ||= proc { true }
            else
              block ||= proc { |_, stream| stream == destination_stream_name }
            end

            records.any? do |record|
              block.(record.entity_id, record.destination_stream_id)
            end
          end
        end
      end
    end
  end
end
