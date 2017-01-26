#!/usr/bin/env ruby

require_relative './script_init'

logger = Log.get __FILE__
logger.info "Starting control index"

Actor::Supervisor.start do
  Controls::Index.start_actors
end
