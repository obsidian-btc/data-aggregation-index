module DataAggregation::Index::Controls
  module SourceEvent
    module Attribute
      def self.some_attribute
        'some value'
      end

      def self.some_time
        Time.example
      end
    end
  end
end
