module DataAggregation::Index
  def self.included(cls)
    unless cls == Object
      cls.send :include, Module
    end
  end

  module Module
    def self.included(mod)
      mod.class_exec do
        extend StreamName
        extend CategoryMacro
      end
    end

    module CategoryMacro
      def category_macro(category)
        category = Casing::Camel.(category, symbol_to_string: true)

        define_singleton_method :category do
          category
        end
      end
      alias_method :category, :category_macro
    end
  end
end
