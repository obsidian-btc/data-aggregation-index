module DataAggregation::Index
  module Update
    class Handler
      include EventStore::Messaging::Handler

      handle Messages::Started do |started, event_data|
        GetNextBatch.(started, event_data)
      end

      handle Messages::BatchAssembled do |batch_assembled, event_data|
        CopyBatch.(batch_assembled, event_data)
      end

      handle Messages::BatchCopied do |batch_copied, event_data|
        GetNextBatch.(batch_copied, event_data)
      end
    end
  end
end
