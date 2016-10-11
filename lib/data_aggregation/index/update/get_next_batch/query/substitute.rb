module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        module Substitute
          def self.build
            Query.new
          end

          class Query < Query
            def call(entity_id, starting_position, ending_position)
              record = queries[entity_id]

              return [] unless record

              record[starting_position..ending_position]
            end

            def add(entity_id, results, position)
              queries[entity_id] = Record.new results, position
            end

            def queries
              @queries ||= {}
            end

            Record = Struct.new :results, :starting_position do
              def [](range)
                range_start = range.begin - starting_position
                range_end = range.end - starting_position

                results[range_start..range_end] || []
              end
            end
          end
        end
      end
    end
  end
end
