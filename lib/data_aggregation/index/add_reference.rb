module DataAggregation::Index
  class AddReference
    include Log::Dependency
    include StreamName

    configure :add_reference

    attr_reader :category

    dependency :clock, Clock::UTC
    dependency :get_positions, Queries::GetPositions
    dependency :update_store, Update::Store
    dependency :writer, EventStore::Messaging::Writer

    def initialize(category)
      @category = category
    end

    def self.build(category)
      instance = new category
      Clock::UTC.configure instance
      Queries::GetPositions.configure instance
      Update::Store.configure instance, category, attr_name: :update_store
      EventStore::Messaging::Writer.configure instance
      instance
    end

    def call(entity_id, related_entity_stream_name)
      log_attributes = "EntityID: #{entity_id}, RelatedEntityStreamName: #{related_entity_stream_name}"
      logger.trace "Adding reference (#{log_attributes})"

      related_entity_id = StreamName.get_id related_entity_stream_name
      related_entity_category = StreamName.get_category related_entity_stream_name

      update = update_store.get related_entity_id

      if update
        logger.debug "Reference already added (#{log_attributes})"
        return
      end

      _, _, reference_list_pos = get_positions.(entity_id, category)

      add_reference_initiated = Update::Messages::AddReferenceInitiated.new
      add_reference_initiated.entity_id = entity_id
      add_reference_initiated.related_entity_id = related_entity_id
      add_reference_initiated.related_entity_category = related_entity_category
      add_reference_initiated.reference_list_position = reference_list_pos unless reference_list_pos == :no_stream
      add_reference_initiated.time = clock.iso8601

      stream_name = update_stream_name related_entity_id, category

      writer.write_initial add_reference_initiated, stream_name

      logger.debug "Reference added (#{log_attributes})"

      add_reference_initiated
    end
  end
end
