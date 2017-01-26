require 'clock/controls'
require 'identifier/uuid/controls'
require 'event_source/controls'

module DataAggregation::Index
  Controls = ::Module.new
end

require 'data_aggregation/index/controls/id'
require 'data_aggregation/index/controls/position'
require 'data_aggregation/index/controls/update/batch'
require 'data_aggregation/index/controls/update/list'
require 'data_aggregation/index/controls/time'

require 'data_aggregation/index/controls/stream_name'
require 'data_aggregation/index/controls/stream_name/causation'
require 'data_aggregation/index/controls/stream_name/category'
require 'data_aggregation/index/controls/stream_name/correlation'
require 'data_aggregation/index/controls/stream_name/entity'
require 'data_aggregation/index/controls/stream_name/event_list'
require 'data_aggregation/index/controls/stream_name/fact_list'
require 'data_aggregation/index/controls/stream_name/index'
require 'data_aggregation/index/controls/stream_name/reference_list'
require 'data_aggregation/index/controls/stream_name/related_entity'
require 'data_aggregation/index/controls/stream_name/reply'
require 'data_aggregation/index/controls/stream_name/update'

require 'data_aggregation/index/controls/messages'
require 'data_aggregation/index/controls/event_list/messages'
require 'data_aggregation/index/controls/reference_list/messages'
require 'data_aggregation/index/controls/update/messages'

require 'data_aggregation/index/controls/update/entity'
require 'data_aggregation/index/controls/update/entity/add_reference'
require 'data_aggregation/index/controls/update/entity/publish_event'

require 'data_aggregation/index/controls/fact_list/entry'
require 'data_aggregation/index/controls/fact_list/projection'

require 'data_aggregation/index/controls/source_event'
require 'data_aggregation/index/controls/source_event/attribute'
require 'data_aggregation/index/controls/source_event/metadata'
require 'data_aggregation/index/controls/source_event/event_data'

require 'data_aggregation/index/controls/write'
require 'data_aggregation/index/controls/index/write'
require 'data_aggregation/index/controls/event_list/write'
require 'data_aggregation/index/controls/fact_list/write'
require 'data_aggregation/index/controls/reference_list/write'

require 'data_aggregation/index/controls/index'
