module DataAggregation::Index::Controls
  module ID
    def self.example(*arguments)
      Identifier::UUID::Controls::Incrementing.example(*arguments)
    end
  end
end
