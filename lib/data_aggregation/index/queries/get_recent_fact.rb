module DataAggregation::Index
  module Queries
    class GetRecentFact
      include Telemetry::Logger::Dependency

      configure :get_recent_fact

      attr_reader :projection_class

      def initialize(projection_class)
        @projection_class = projection_class
      end

      def self.build(projection_class)
        new projection_class
      end

      def call(stream_name, update_id, starting_position=nil, &block)
        log_attributes = "StreamName: #{stream_name}, UpdateID: #{update_id}, StartingPosition: #{starting_position.inspect}"
        logger.trace "Get recent fact (#{log_attributes})"

        entity = Set.new

        projection = projection_class.build(
          entity,
          stream_name,
          starting_position: starting_position
        )

        ending_position = projection.()
        ending_position ||= :no_stream

        if entity.include? update_id
          log_message = "Recent fact found"
          block.(ending_position)
        else
          log_message = "Recent fact not found"
        end

        logger.debug "#{log_message} (#{log_attributes}, EndingPosition: #{ending_position})"

        ending_position
      end
    end
  end
end
