require 'event_store/messaging'
require 'event_store/entity_store'

module DataAggregation
  Index = Module.new
end

require 'data_aggregation/index/stream_name'

require 'data_aggregation/index/update/entity'
require 'data_aggregation/index/update/messages'
require 'data_aggregation/index/update/projection'
require 'data_aggregation/index/update/store'

require 'data_aggregation/index/event_data/serializer'
require 'data_aggregation/index/get_positions'
require 'data_aggregation/index/index'
require 'data_aggregation/index/messages'
require 'data_aggregation/index/recent_list_entry_query'
require 'data_aggregation/index/recent_list_entry_query/substitute'

require 'data_aggregation/index/event_list/add'
require 'data_aggregation/index/event_list/update_index'
require 'data_aggregation/index/event_list/handler'
require 'data_aggregation/index/reference_list/add'
require 'data_aggregation/index/reference_list/update_index'
require 'data_aggregation/index/reference_list/handler'

require 'data_aggregation/index/add_reference'
require 'data_aggregation/index/add_reference/substitute'
require 'data_aggregation/index/publish_event'
require 'data_aggregation/index/publish_event/substitute'

require 'data_aggregation/index/update/get_next_batch/query'
require 'data_aggregation/index/update/get_next_batch/query/substitute'
#require 'data_aggregation/index/update/get_next_batch/query/references'
#require 'data_aggregation/index/update/get_next_batch/query/published_events'
require 'data_aggregation/index/update/get_next_batch'

require 'data_aggregation/index/handler'
