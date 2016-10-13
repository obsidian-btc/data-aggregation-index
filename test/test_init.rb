ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'

if ENV['LOG_LEVEL']
  ENV['LOGGER'] ||= 'on'
else
  ENV['LOG_LEVEL'] ||= 'trace'
end

ENV['LOGGER'] ||= 'off'
ENV['ENTITY_CACHE_SCOPE'] ||= 'exclusive'

require 'pp'

require_relative '../init.rb'
require 'data_aggregation/index/controls'
require 'fixtures/expect_message'

require 'test_bench/activate'

Telemetry::Logger::AdHoc.activate

include DataAggregation::Index
