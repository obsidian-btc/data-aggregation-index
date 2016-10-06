require 'event_store/messaging'

module DataAggregation
  Index = Module.new
end

require 'data_aggregation/index/event_data/serializer'
require 'data_aggregation/index/index'
require 'data_aggregation/index/messages'
require 'data_aggregation/index/stream_name'
