module DataAggregation::Index::Controls
  module Update
    module Messages
      def self.example
        Started.example
      end

      module PublishEventInitiated
        def self.example(i=nil, list_position: nil)
          unless list_position == false
            list_position ||= Position::EventList.example
          end

          event_data_text = SourceEvent::EventData::Text.example i

          event = SourceEvent.example

          message = DataAggregation::Index::Update::Messages::PublishEventInitiated.follow event, strict: false
          message.entity_id = ID::Entity.example
          message.event_id = ID::SourceEvent.example i
          message.event_data_text = event_data_text
          message.event_list_position = list_position if list_position
          message.time = Time.example
          message
        end
      end

      module AddReferenceInitiated
        def self.example(i=nil, list_position: nil)
          unless list_position == false
            list_position ||= Position::ReferenceList.example
          end

          message = DataAggregation::Index::Update::Messages::AddReferenceInitiated.new
          message.entity_id = ID::Entity.example
          message.related_entity_id = ID::RelatedEntity.example i
          message.related_entity_category = StreamName::RelatedEntity::Category.example
          message.reference_list_position = list_position if list_position
          message
        end
      end

      module Started
        def self.example(event_list_position: nil, reference_list_position: nil)
          event_list_position = Position::EventList.example if event_list_position == true
          reference_list_position = Position::ReferenceList.example if reference_list_position == true

          message = DataAggregation::Index::Update::Messages::Started.new
          message.update_id = ID::Update.example
          message.event_list_position = event_list_position if event_list_position
          message.reference_list_position = reference_list_position if reference_list_position
          message.time = Time.example
          message
        end
      end

      module BatchAssembled
        def self.example(batch_index=nil)
          message = DataAggregation::Index::Update::Messages::BatchAssembled.new
          message.update_id = ID::Update.example
          message.batch_position = Batch::Position::Stop.example batch_index
          message.batch_data = Batch::Data.example batch_index
          message.time = Time.example
          message
        end
      end

      module BatchCopied
        def self.example(batch_index=nil)
          message = DataAggregation::Index::Update::Messages::BatchCopied.new
          message.update_id = ID::Update.example
          message.copy_position = Batch::Position::Stop.example batch_index
          message.time = Time.example
          message
        end
      end

      module CopyFailed
        def self.example(batch_index=nil, messages_copied: nil)
          messages_copied ||= MessagesCopied.example

          copy_position = Batch::Position.example batch_index, offset: messages_copied.pred

          message = DataAggregation::Index::Update::Messages::CopyFailed.new
          message.update_id = ID::Update.example
          message.batch_position = Batch::Position::Stop.example batch_index
          message.batch_data = Batch::Data.example offset: messages_copied
          message.copy_position = copy_position
          message.time = Time.example
          message
        end

        module MessagesCopied
          def self.example
            2
          end
        end
      end

      module Completed
        def self.example
          message = DataAggregation::Index::Update::Messages::Completed.new
          message.update_id = ID::Update.example
          message.time = Time.example
          message
        end
      end
    end
  end
end
