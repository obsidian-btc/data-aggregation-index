module DataAggregation::Index
  class PublishEvent
    module Substitute
      def self.build
        PublishEvent.new
      end

      class PublishEvent
        def call(entity_id, event)
          record = Record.new entity_id, event
          records << record
          record
        end

        def records
          @records ||= []
        end

        Record = Struct.new :entity_id, :event

        module Assertions
          def published_event?(event=nil, &block)
            if event.nil?
              block ||= proc { true }
            else
              block ||= proc { |_, msg| msg == event }
            end

            records.any? do |record|
              block.(record.entity_id, record.event)
            end
          end
        end
      end
    end
  end
end
