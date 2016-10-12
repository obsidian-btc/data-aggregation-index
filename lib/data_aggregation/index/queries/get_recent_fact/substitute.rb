module DataAggregation::Index
  module Queries
    class GetRecentFact
      module Substitute
        def self.build
          GetRecentFact.new
        end

        class GetRecentFact
          def call(stream_name, update_id, starting_position=nil, &block)
            starting_position ||= 0

            stream = streams[stream_name]

            return :no_stream if stream.nil?

            if stream.version >= starting_position && stream.update_id == update_id
              block.() if block
            end

            stream.version
          end

          def set(stream_name, update_id=nil, version: nil)
            version ||= 0

            stream = Stream.new version, update_id
            streams[stream_name] = stream
            stream
          end

          def streams
            @streams ||= {}
          end

          Stream = Struct.new :version, :update_id
        end
      end
    end
  end
end
