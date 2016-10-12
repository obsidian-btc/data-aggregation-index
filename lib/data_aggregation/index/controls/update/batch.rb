module DataAggregation::Index::Controls
  module Update
    module Batch
      module Data
        def self.example(batch_index=nil)
          batch_index ||= 0

          batch_size = Size.example
          base = batch_index * batch_size + 1

          batch_size.times.map do |offset|
            number = base + offset

            "result-#{number}"
          end
        end
      end

      module EventData
        def self.example
          batch_size = Size.example

          (0..batch_size).map do |i|
            SourceEvent::EventData::Write.example i
          end
        end

        module Text
          def self.example
            event_data_list = EventData.example
            event_data_list.map do |event_data|
              Serialize::Write.(event_data, :json)
            end
          end
        end
      end

      module Position
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
      end

      module Size
        def self.example
          3
        end
      end
    end
  end
end
