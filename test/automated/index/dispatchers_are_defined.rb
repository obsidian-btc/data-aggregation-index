require_relative '../automated_init'

context "Dispatchers are defined" do
  context "Index stream dispatcher" do
    dispatcher = Controls::Index::Dispatchers::Index

    test do
      event = Controls::Messages.example

      handler, * = dispatcher.handler_registry.get event

      assert handler.instance_of?(Handler)
    end
  end

  context "Event list stream dispatcher" do
    dispatcher = Controls::Index::Dispatchers::EventList

    test do
      event = Controls::EventList::Messages.example

      handler, * = dispatcher.handler_registry.get event

      assert handler.instance_of?(EventList::Handler)
    end
  end

  context "Reference list stream dispatcher" do
    dispatcher = Controls::Index::Dispatchers::ReferenceList

    test do
      event = Controls::ReferenceList::Messages.example

      handler, * = dispatcher.handler_registry.get event

      assert handler.instance_of?(ReferenceList::Handler)
    end
  end

  context "Update stream dispatcher" do
    dispatcher = Controls::Index::Dispatchers::Update

    test do
      event = Controls::Update::Messages.example

      handler, * = dispatcher.handler_registry.get event

      assert handler.instance_of?(Update::Handler)
    end
  end
end
