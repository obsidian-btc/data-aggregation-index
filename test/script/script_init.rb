ENV['LOG_LEVEL'] ||= 'trace'

require_relative '../test_init'

module Defaults
  def self.iteration_count
    @iteration_count ||=
      begin
        count = ENV['ITERATION_COUNT'].to_i
        count = 100 if count.zero?
        count
      end
  end
end
