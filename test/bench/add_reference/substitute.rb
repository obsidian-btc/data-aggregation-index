require_relative '../bench_init'

context "Add reference substitute" do
  destination_stream_name = Controls::StreamName::RelatedEntity.example

  context "Reference added predicate" do
    context "Substitute has not been actuated" do
      substitute = SubstAttr::Substitute.build AddReference

      test "Predicate returns false when no argument is specified" do
        refute substitute, &:reference_added?
      end
    end

    context "Substitute has been actuated" do
      substitute = SubstAttr::Substitute.build AddReference
      substitute.(destination_stream_name)

      test "Predicate returns true when no argument is specified" do
        assert substitute, &:reference_added?
      end

      test "Predicate returns true if destination stream is passed in as argument" do
        assert substitute do
          reference_added? destination_stream_name
        end

        refute substitute do
          reference_added? Object.new
        end
      end
    end
  end
end
