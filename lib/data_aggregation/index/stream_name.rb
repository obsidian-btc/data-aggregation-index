module DataAggregation::Index
  module StreamName
    extend self

    def event_list_stream_name(entity_id, category)
      category = "#{category}:events"

      stream_name entity_id, category
    end

    def reference_list_stream_name(entity_id, category)
      category = "#{category}:references"

      stream_name entity_id, category
    end

    def index_stream_name(stream_id, category)
      stream_name stream_id, category
    end

    def update_stream_name(update_id, category)
      category = "#{category}:update"

      stream_name update_id, category
    end

    def stream_name(stream_id, category)
      EventStore::Messaging::StreamName.stream_name stream_id, category
    end

    def self.get_category(stream_name)
      category = EventStore::Messaging::StreamName.get_category stream_name
      category.gsub! /:.*\Z/, ''
      category
    end
  end
end
