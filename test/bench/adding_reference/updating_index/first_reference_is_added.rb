require_relative '../../bench_init'

context "Updating index upon a reference being added, first reference is added" do
  reference_list_version = Controls::Position::ReferenceList.example
  reference_added = Controls::Messages::ReferenceAdded.example reference_list_version
  category = Controls::StreamName::Category.example
  index_stream_name = Controls::StreamName::Index.example

  update_index = ReferenceList::UpdateIndex.new reference_added, category

  update_started = update_index.()

  test "Reference list position is set to zero" do
    assert update_started.reference_list_position == 0
  end
end
