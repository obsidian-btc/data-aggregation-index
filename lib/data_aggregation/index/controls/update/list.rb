module DataAggregation::Index::Controls
  module Update
    module List
      module Position
        def self.example
          Size.example - 1
        end

        module Previous
          def self.example
            Position.example - 1
          end
        end
      end

      module Size
        def self.example
          6
        end
      end
    end
  end
end
