require_relative '../../automated_init'

context "Add reference to reference list command is configured" do
  add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example
  event_data = Controls::EventData::Update.example

  context do
    add = ReferenceList::Add.build add_reference_initiated, event_data

    test "Category is set" do
      assert add.category == Controls::StreamName::Category.example
    end
  end

  context "Session is specified" do
    session = Object.new

    add = ReferenceList::Add.build add_reference_initiated, event_data, session: session

    test "Session is passed to writer" do
      assert add.writer do
        session? session
      end
    end
  end
end
