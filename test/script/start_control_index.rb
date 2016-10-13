#!/usr/bin/env ruby

ENV['LOG_LEVEL'] ||= 'info'

require_relative './script_init'

require 'process_host'

cooperation = ProcessHost::Cooperation.build

Controls::Index.configure_process_host cooperation

logger = Telemetry::Logger.get __FILE__
logger.info "Starting control index"

cooperation.start!
