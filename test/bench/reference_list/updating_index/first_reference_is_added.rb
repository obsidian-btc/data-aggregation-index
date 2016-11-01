require_relative '../../bench_init'

context "Updating index upon a reference being added, first reference is added" do
  reference_added = Controls::ReferenceList::Messages::Added.example
  category = Controls::StreamName::Category.example

  update_index = ReferenceList::UpdateIndex.new reference_added, category, 0

  update_started = update_index.()

  test "Reference list position is set to zero" do
    assert update_started.reference_list_position == 0
  end
end
