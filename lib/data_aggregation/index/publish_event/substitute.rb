module DataAggregation::Index
  class PublishEvent
    module Substitute
      def self.build
        PublishEvent.new
      end

      class PublishEvent
        def call(event)
          published_events << event
        end

        def published_events
          @published_events ||= []
        end

        module Assertions
          def published_event?(event=nil, &block)
            if event.nil?
              block ||= proc { true }
            else
              block ||= proc { |e| e == event }
            end

            published_events.any? &block
          end
        end
      end
    end
  end
end
