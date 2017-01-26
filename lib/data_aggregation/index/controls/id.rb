module DataAggregation::Index::Controls
  module ID
    def self.example(*arguments)
      Identifier::UUID::Controls::Incrementing.example(*arguments)
    end

    module Entity
      def self.example
        ID.example 1
      end
    end

    module RelatedEntity
      def self.example(i=nil)
        i ||= Position::ReferenceList.example
        i += 100

        ID.example i
      end
    end

    module SourceEvent
      def self.example(i=nil, stream_id: nil)
        i ||= Position::EventList.example
        stream_id ||= Entity.example

        "#{stream_id}-#{i}"
      end
    end

    module Update
      def self.example(i=nil)
        i ||= 0
        i += 300

        ID.example i
      end
    end
  end
end
