module DataAggregation::Index::Controls
  module Update
    module Batch
      module Data
        def self.example(batch_index=nil, offset: nil)
          batch_index ||= 0
          offset ||= 0

          batch_size = Size.example

          (offset...batch_size).map do |offset|
            Entry.example batch_index, offset: offset
          end
        end

        module Entry
          def self.example(batch_index=nil, offset: nil)
            batch_index ||= 0
            offset ||= 0

            batch_size = Size.example
            number = batch_index * batch_size + offset + 1

            "update-data-entry-#{number}"
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
              Transform::Write.(event_data, :json)
            end
          end
        end
      end

      module Position
        def self.example(batch_index=nil, offset: nil)
          batch_index ||= 0
          offset ||= 0

          batch_index * Size.example + offset
        end

        module Failed
          def self.example(batch_index=nil, messages_copied: nil)
            messages_copied ||= Messages::CopyFailed::MessagesCopied.example
            offset = messages_copied - 1

            Position.example batch_index, offset: offset
          end
        end

        module Start
          def self.example(batch_index=nil)
            Position.example batch_index
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
