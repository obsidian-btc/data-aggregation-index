module DataAggregation
  module Index
    module ActorIntegration
      def start_actors
        index_stream_name = ActorIntegration.category_stream index_category(category)
        self::Consumers::Index.start index_stream_name

        event_list_stream_name = ActorIntegration.category_stream event_list_category(category)
        self::Consumers::EventList.start event_list_stream_name

        reference_list_stream_name = ActorIntegration.category_stream reference_list_category(category)
        self::Consumers::ReferenceList.start reference_list_stream_name

        update_stream_name = ActorIntegration.category_stream update_category(category)
        self::Consumers::Update.start update_stream_name
      end

      def self.category_stream(category)
        EventSource::EventStore::HTTP::StreamName.canonize category
      end
    end
  end
end
