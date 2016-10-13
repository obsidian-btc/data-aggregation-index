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

      add_reference_mod = ::Module.new do
        define_singleton_method :configure do |receiver, attr_name: nil|
          attr_name ||= :add_reference

          instance = build
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        define_singleton_method :build do
          category = mod.category

          AddReference.build category
        end

        const_set :Substitute, AddReference::Substitute
      end
      mod.const_set :AddReference, add_reference_mod

      publish_event_mod = ::Module.new do
        define_singleton_method :configure do |receiver, attr_name: nil|
          attr_name ||= :publish_event

          instance = build
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        define_singleton_method :build do
          category = mod.category

          PublishEvent.build category
        end

        const_set :Substitute, PublishEvent::Substitute
      end
      mod.const_set :PublishEvent, publish_event_mod
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
