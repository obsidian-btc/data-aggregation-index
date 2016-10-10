module DataAggregation::Index::Controls
  module RecentListEntryQuery
    module Projection
      class Example
        include EventStore::EntityProjection

        apply ListEntry::ExampleMessage do |msg|
          entity << msg.list_entry_id
        end
      end
    end
  end
end
