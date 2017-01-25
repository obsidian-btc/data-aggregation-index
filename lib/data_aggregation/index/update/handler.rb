module DataAggregation::Index
  module Update
    class Handler
      include EventStore::Messaging::Handler

      dependency :session, EventSource::EventStore::HTTP::Session

      def configure
        EventSource::EventStore::HTTP::Session.configure self
      end

      handle Messages::AddReferenceInitiated do |initiated, event_data|
        ReferenceList::Add.(initiated, event_data, session: session)
      end

      handle Messages::PublishEventInitiated do |initiated, event_data|
        EventList::Add.(initiated, event_data, session: session)
      end

      handle Messages::Started do |started, event_data|
        GetNextBatch.(started, event_data, session: session)
      end

      handle Messages::BatchAssembled do |batch_assembled, event_data|
        CopyBatch.(batch_assembled, event_data, session: session)
      end

      handle Messages::BatchCopied do |batch_copied, event_data|
        GetNextBatch.(batch_copied, event_data, session: session)
      end

      handle Messages::CopyFailed do |copy_failed, event_data|
        CopyBatch.(copy_failed, event_data, session: session)
      end
    end
  end
end
