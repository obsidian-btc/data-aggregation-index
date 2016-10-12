module DataAggregation::Index
  module Update
    class CopyBatch
      class Copy
        module Substitute
          def self.build
            Copy.new
          end

          class Copy
            def call(data)
              record = Record.new data
              records << record
              record
            end

            def records
              @records ||= []
            end

            Record = Struct.new :data

            module Assertions
              def copied?(data=nil, &block)
                if data.nil?
                  block ||= proc { true }
                else
                  block ||= proc { |_data| data == _data }
                end

                records.any? do |record|
                  block.(record.data)
                end
              end
            end
          end
        end
      end
    end
  end
end
