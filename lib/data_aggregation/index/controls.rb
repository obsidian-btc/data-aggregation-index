require 'clock/controls'
require 'identifier/uuid/controls'
require 'event_store/messaging/controls'

module DataAggregation::Index
  Controls = ::Module.new
end

require 'data_aggregation/index/controls/event'
require 'data_aggregation/index/controls/event_data'
require 'data_aggregation/index/controls/id'
require 'data_aggregation/index/controls/messages'
require 'data_aggregation/index/controls/position'
require 'data_aggregation/index/controls/stream_name'
require 'data_aggregation/index/controls/stream_name/event_list'
require 'data_aggregation/index/controls/stream_name/index'
require 'data_aggregation/index/controls/stream_name/reference_list'
require 'data_aggregation/index/controls/stream_name/related_entity'
require 'data_aggregation/index/controls/stream_name/update'
require 'data_aggregation/index/controls/time'
require 'data_aggregation/index/controls/update/entity'
require 'data_aggregation/index/controls/update/messages'
