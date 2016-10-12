module DataAggregation::Index::Controls
  module FactList
    module Projection
      class Example
        include EventStore::EntityProjection

        apply Entry::ExampleMessage do |msg|
          entity << msg.update_id
        end
      end
    end
  end
end
