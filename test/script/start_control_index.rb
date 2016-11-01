#!/usr/bin/env ruby

require_relative './script_init'

require 'event_store/consumer'
require 'actor'

logger = Telemetry::Logger.get __FILE__
logger.info "Starting control index"

Actor::Supervisor.run do
  Controls::Index.start_actors
end
