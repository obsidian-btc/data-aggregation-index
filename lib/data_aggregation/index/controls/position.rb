module DataAggregation::Index::Controls
  module Position
    module Index
      def self.example
        33
      end
    end

    module EventList
      def self.example
        11
      end

      module Previous
        def self.example
          EventList.example - 1
        end
      end
    end

    module ReferenceList
      def self.example
        22
      end

      module Previous
        def self.example
          ReferenceList.example - 1
        end
      end
    end

    module FactList
      def self.example
        Update::List::Position.example
      end
    end
  end
end
