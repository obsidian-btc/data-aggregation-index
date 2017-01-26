require_relative '../../automated_init'

context "Add reference to reference list command is configured" do
  add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example

  context do
    add = ReferenceList::Add.build add_reference_initiated

    test "Category is set" do
      assert add.category == Controls::StreamName::Category.example
    end
  end

  context "Session is specified" do
    session = EventSource::EventStore::HTTP::Session.build

    add = ReferenceList::Add.build add_reference_initiated, session: session

    test "Session is passed to.write" do
      assert add.write do
        session? session
      end
    end
  end
end
