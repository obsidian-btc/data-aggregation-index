module DataAggregation::Index
  module Update
    class Handler
      include Messaging::Handle

      dependency :session, EventSource::EventStore::HTTP::Session

      def configure
        EventSource::EventStore::HTTP::Session.configure self
      end

      handle Messages::AddReferenceInitiated do |initiated|
        ReferenceList::Add.(initiated, session: session)
      end

      handle Messages::PublishEventInitiated do |initiated|
        EventList::Add.(initiated, session: session)
      end

      handle Messages::Started do |started|
        GetNextBatch.(started, session: session)
      end

      handle Messages::BatchAssembled do |batch_assembled|
        CopyBatch.(batch_assembled, session: session)
      end

      handle Messages::BatchCopied do |batch_copied|
        GetNextBatch.(batch_copied, session: session)
      end

      handle Messages::CopyFailed do |copy_failed|
        CopyBatch.(copy_failed, session: session)
      end
    end
  end
end
