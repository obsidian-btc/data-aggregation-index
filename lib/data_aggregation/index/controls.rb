require 'clock/controls'
require 'identifier/uuid/controls'
require 'event_store/messaging/controls'

module DataAggregation::Index
  Controls = ::Module.new
end

require 'data_aggregation/index/controls/id'
require 'data_aggregation/index/controls/time'
