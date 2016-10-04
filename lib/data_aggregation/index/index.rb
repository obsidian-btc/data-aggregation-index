module DataAggregation::Index
  def self.included(cls)
    unless cls == Object
      cls.send :include, Module
    end
  end

  module Module
  end
end
