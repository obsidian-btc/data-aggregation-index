module DataAggregation::Index
  class RecentListEntryQuery
    include Telemetry::Logger::Dependency

    configure :recent_list_entry_query

    attr_reader :projection_class

    def initialize(projection_class)
      @projection_class = projection_class
    end

    def self.build(projection_class)
      new projection_class
    end

    def call(stream_name, update_id, starting_position=nil, &block)
      log_attributes = "StreamName: #{stream_name}, UpdateID: #{update_id}, StartingPosition: #{starting_position}"
      logger.trace "Query recent list entry (#{log_attributes})"

      entity = Set.new

      projection = projection_class.build entity, stream_name, starting_position: starting_position

      ending_position = projection.()
      ending_position ||= :no_stream

      if entity.include? update_id
        log_message = "Recent list entry found"
        block.()
      else
        log_message = "Recent list entry not found"
      end

      logger.debug "#{log_message} (#{log_attributes}, EndingPosition: #{ending_position})"

      ending_position
    end
  end
end
