ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

ENV['ENTITY_CACHE_SCOPE'] ||= 'exclusive'

require_relative '../init.rb'

require 'data_aggregation/index/controls'
require 'fixtures/expect_message'

require 'test_bench/activate'

require 'pp'

include DataAggregation::Index
