module DataAggregation::Index
  module Update
    class GetNextBatch
      class Query
        include Telemetry::Logger::Dependency
        include StreamName

        configure :query

        attr_accessor :category

        abstract :call
      end
    end
  end
end
