module DataAggregation
  module Index
    module ActorIntegration
      def start_actors
        self::Consumers::Index.start
        self::Consumers::EventList.start
        self::Consumers::ReferenceList.start
        self::Consumers::Update.start
      end
    end
  end
end
