module DataAggregation
  module Index
    module ActorIntegration
      def start_actors
        index_stream_name = index_category_stream_name(category)
        self::Consumers::Index.start index_stream_name

        event_list_stream_name = event_list_category_stream_name(category)
        self::Consumers::EventList.start event_list_stream_name

        reference_list_stream_name = reference_list_category_stream_name(category)
        self::Consumers::ReferenceList.start reference_list_stream_name

        update_stream_name = update_category_stream_name(category)
        self::Consumers::Update.start update_stream_name
      end
    end
  end
end
