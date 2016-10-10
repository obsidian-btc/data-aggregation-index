module DataAggregation::Index
  class RecentListEntryQuery
    module Substitute
      def self.build
        RecentListEntryQuery.new
      end

      class RecentListEntryQuery
        def call(stream_name, update_id, starting_position=nil, &block)
          starting_position ||= 0

          position = streams[stream_name]

          return :no_stream if position.nil?

          if position >= starting_position
            block.()
          end

          position
        end

        def set(stream_name, update_id, position=nil)
          position ||= 0

          streams[stream_name] = position
        end

        def streams
          @streams ||= {}
        end
      end
    end
  end
end
