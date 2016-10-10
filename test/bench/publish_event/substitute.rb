require_relative '../bench_init'

context "Publish event substitute" do
  event = Controls::SourceEvent.example

  context "Published predicate" do
    context "Substitute has not been actuated" do
      substitute = SubstAttr::Substitute.build PublishEvent

      test "Predicate returns false when no block is specified" do
        refute substitute, &:published_event?
      end
    end

    context "Substitute has been actuated" do
      substitute = SubstAttr::Substitute.build PublishEvent
      substitute.(event)

      test "Predicate returns true when no block is specified" do
        assert substitute, &:published_event?
      end

      test "Predicate returns true if event is passed in as argument" do
        assert substitute do published_event? event end
        refute substitute do published_event? Object.new end
      end

      test "Predicate returns true if block evaluates to true" do
        assert substitute do
          published_event? { |e| e == event}
        end

        refute substitute do
          published_event? { false }
        end
      end
    end
  end
end
