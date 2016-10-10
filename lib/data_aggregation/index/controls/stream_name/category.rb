module DataAggregation::Index::Controls
  module StreamName
    module Category
      def self.example(random: nil)
        category = 'someIndex'

        if random
          uuid = Identifier::UUID::Random.get

          category = "#{category}#{uuid.gsub '-', ''}"
        end

        category
      end
    end
  end
end
