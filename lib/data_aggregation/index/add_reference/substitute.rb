module DataAggregation::Index
  class AddReference
    module Substitute
      def self.build
        AddReference.new
      end

      class AddReference
        def call(destination_stream_name)
          streams << destination_stream_name
        end

        def reference_added?(destination_stream_name=nil)
          if destination_stream_name.nil?
            block = proc { true }
          else
            block = proc { |stream| stream == destination_stream_name }
          end

          streams.any? &block
        end

        def streams
          @streams ||= []
        end
      end
    end
  end
end
