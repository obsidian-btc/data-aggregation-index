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
      def self.example(i=nil)
        i ||= Position::EventList.example
        i += 200

        ID.example i
      end
    end

    module Update
      def self.example
        SourceEvent.example
      end
    end
  end
end
