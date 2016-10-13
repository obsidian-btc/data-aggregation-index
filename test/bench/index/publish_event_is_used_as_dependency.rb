require_relative '../bench_init'

context "PublishEvent command specialized for index is used as dependency" do
  context "Implementation is configured" do
    receiver = OpenStruct.new

    Controls::Index::PublishEvent.configure receiver

    publish_event = receiver.publish_event

    test "Category is set" do
      assert publish_event.category == Controls::StreamName::Category.example
    end
  end

  context "Substitute is built" do
    substitute = SubstAttr::Substitute.build Controls::Index::PublishEvent

    test "PublishEvent substitute is returned" do
      assert substitute.instance_of?(PublishEvent::Substitute::PublishEvent)
    end
  end
end

