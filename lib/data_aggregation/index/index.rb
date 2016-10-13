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
        extend ConfigureProcessHost
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
      end
      alias_method :category, :category_macro
    end

    module ConfigureProcessHost
      def configure_process_host(process_host)
        index_category_stream = StreamName.index_category_stream_name category 
        index_consumer = EventStore::Consumer.build "$ce-#{index_category_stream}", self::Dispatchers::Index

        event_list_category_stream = StreamName.event_list_category_stream_name category
        event_list_consumer = EventStore::Consumer.build "$ce-#{event_list_category_stream}", self::Dispatchers::EventList

        reference_list_category_stream = StreamName.reference_list_category_stream_name category
        reference_list_consumer = EventStore::Consumer.build "$ce-#{reference_list_category_stream}", self::Dispatchers::ReferenceList

        update_category_stream = StreamName.update_category_stream_name category
        update_consumer = EventStore::Consumer.build "$ce-#{update_category_stream}", self::Dispatchers::Update

        process_host.register index_consumer, "#{category}-index-consumer"
        process_host.register event_list_consumer, "#{category}-event-list-consumer"
        process_host.register reference_list_consumer, "#{category}-reference-list-consumer"
        process_host.register update_consumer, "#{category}-update-consumer"
      end
    end
  end
end
