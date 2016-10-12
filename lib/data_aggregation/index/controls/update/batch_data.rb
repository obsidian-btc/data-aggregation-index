module DataAggregation::Index::Controls
  module Update
    module BatchData
      def self.example(batch_index=nil)
        batch_index ||= 0

        batch_size = Position::Batch::Size.example
        base = batch_index * batch_size + 1

        batch_size.times.map do |offset|
          number = base + offset

          "result-#{offset}"
        end
      end
    end
  end
end
