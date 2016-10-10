require_relative '../bench_init'

context "Adding reference to an event list, reference is already added" do
  category = Controls::StreamName::Category.example
  related_entity_id = Controls::ID::RelatedEntity.example
  add_reference_initiated = Controls::Update::Messages::AddReferenceInitiated.example
  reference_list_stream_name = Controls::StreamName::ReferenceList.example
  reference_list_version = Controls::Position::ReferenceList.example

  add = ReferenceList::Add.new add_reference_initiated, category
  add.clock.now = Controls::Time::Raw.example
  add.recent_reference_added_query.set(
    reference_list_stream_name,
    related_entity_id,
    version: reference_list_version
  )

  add.()

  test "Nothing is written" do
    refute add.writer do
      written?
    end
  end
end
