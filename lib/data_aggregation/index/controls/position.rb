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

    module Update
      module List
        def self.example
          total_messages = Batch::Size.example * Batch::Count.example
          total_messages - 1
        end

        module Previous
          def self.example
            List.example - 1
          end
        end
      end
    end

    module Batch
      module Start
        def self.example(batch_index=nil)
          batch_index ||= 0

          batch_index * Size.example
        end
      end

      module Stop
        def self.example(batch_index=nil)
          start = Start.example batch_index

          start + Size.example - 1
        end
      end

      module Count
        def self.example
          2
        end
      end

      module Size
        def self.example
          3
        end
      end
    end
  end
end
