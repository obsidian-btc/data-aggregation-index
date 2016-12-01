require_relative '../automated_init'

context "AddReference command specialized for index is used as dependency" do
  context "Implementation is configured" do
    receiver = OpenStruct.new

    Controls::Index::AddReference.configure receiver

    add_reference = receiver.add_reference

    test "Category is set" do
      assert add_reference.category == Controls::StreamName::Category.example
    end
  end

  context "Substitute is built" do
    substitute = SubstAttr::Substitute.build Controls::Index::AddReference

    test "AddReference substitute is returned" do
      assert substitute.instance_of?(AddReference::Substitute::AddReference)
    end
  end
end
