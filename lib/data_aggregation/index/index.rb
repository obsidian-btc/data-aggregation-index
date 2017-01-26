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
        extend ActorIntegration
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

      mod.const_set :Dispatchers, Dispatchers
    end

    module CategoryMacro
      def category_macro(category)
        category = Casing::Camel.(category, symbol_to_string: true)

        define_singleton_method :category do
          category
        end

        consumers_mod = ::Module.new do
          index_consumer = Class.new do
            include Consumer::EventStore
            include EventStore::Consumer::ErrorHandler
            #category StreamName.index_category(category)
            #dispatcher Dispatchers::Index
          end
          const_set :Index, index_consumer

          event_list_consumer = Class.new do
            include Consumer::EventStore
            include EventStore::Consumer::ErrorHandler
            #category StreamName.event_list_category(category)
            #dispatcher Dispatchers::EventList
          end
          const_set :EventList, event_list_consumer

          reference_list_consumer = Class.new do
            include Consumer::EventStore
            include EventStore::Consumer::ErrorHandler
            #category StreamName.reference_list_category(category)
            #dispatcher Dispatchers::ReferenceList
          end
          const_set :ReferenceList, reference_list_consumer

          update_consumer = Class.new do
            include Consumer::EventStore
            include EventStore::Consumer::ErrorHandler
            #category StreamName.update_category(category)
            #dispatcher Dispatchers::Update
          end
          const_set :Update, update_consumer
        end
        const_set :Consumers, consumers_mod
      end
      alias_method :category, :category_macro
    end
  end
end
