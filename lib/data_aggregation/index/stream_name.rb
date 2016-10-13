module DataAggregation::Index
  module StreamName
    extend self

    def event_list_stream_name(entity_id, category)
      category = event_list_category category

      stream_name entity_id, category
    end

    def event_list_category_stream_name(category)
      category = event_list_category category

      EventStore::Messaging::StreamName.category_stream_name category
    end

    def event_list_category(category)
      "#{category}:events"
    end

    def index_stream_name(stream_id, category)
      category = index_category category

      stream_name stream_id, category
    end

    def index_category(category)
      category
    end

    def index_category_stream_name(category)
      category = index_category category

      EventStore::Messaging::StreamName.category_stream_name category
    end

    def reference_list_stream_name(entity_id, category)
      category = reference_list_category category

      stream_name entity_id, category
    end

    def reference_list_category(category)
      "#{category}:references"
    end

    def reference_list_category_stream_name(category)
      category = reference_list_category category

      EventStore::Messaging::StreamName.category_stream_name category
    end

    def update_stream_name(update_id, category)
      category = update_category category

      stream_name update_id, category
    end

    def update_category(category)
      "#{category}:update"
    end

    def update_category_stream_name(category)
      category = update_category category

      EventStore::Messaging::StreamName.category_stream_name category
    end

    def stream_name(stream_id, category)
      EventStore::Messaging::StreamName.stream_name stream_id, category
    end

    def self.get_id(stream_name)
      EventStore::Messaging::StreamName.get_id stream_name
    end

    def self.get_category(stream_name)
      category = EventStore::Messaging::StreamName.get_category stream_name
      category.gsub! /:.*\Z/, ''
      category
    end
  end
end
