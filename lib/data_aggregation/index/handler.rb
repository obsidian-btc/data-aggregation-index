module DataAggregation::Index
  class Handler
    include Telemetry::Logger::Dependency
    include EventStore::Messaging::Handler
    include StreamName

    dependency :clock, Clock::UTC
    dependency :update_store, Update::Store
    dependency :writer, EventStore::Messaging::Writer

    def configure
      Clock::UTC.configure self
      Update::Store.configure self, attr_name: :update_store
      EventStore::Messaging::Writer.configure self
    end

    handle Messages::UpdateStarted do |update_started, event_data|
      update_id = update_started.update_id
      index_stream_name = event_data.stream_name
      category = StreamName.get_category index_stream_name

      log_attributes = "UpdateID: #{update_id}, Category: #{category}, EntityID: #{update_started.entity_id}, EventListPosition: #{update_started.event_list_position}, ReferenceListPosition: #{update_started.reference_list_position}"
      logger.trace "Recording update has started (#{log_attributes})"

      entity, version = update_store.get update_id, include: :version

      if entity.started?
        logger.debug "Update started has already been recorded; skipped (#{log_attributes})"
        return
      end

      started = Update::Messages::Started.proceed(
        update_started,
        include: %i(update_id event_list_position reference_list_position)
      )
      started.time = clock.iso8601

      stream_name = update_stream_name update_id, category

      writer.write started, stream_name, expected_version: version

      logger.debug "Update started recorded (#{log_attributes})"

      started
    end
  end
end
