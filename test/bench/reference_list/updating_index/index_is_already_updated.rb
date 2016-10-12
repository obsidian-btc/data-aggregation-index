require_relative '../../bench_init'

context "Updating index upon a reference being added, index is already updated" do
  reference_list_version = Controls::Position::ReferenceList.example
  reference_added = Controls::ReferenceList::Messages::Added.example reference_list_version
  category = Controls::StreamName::Category.example
  index_stream_name = Controls::StreamName::Index.example

  update_index = ReferenceList::UpdateIndex.new reference_added, category
  update_index.get_positions.set(
    index_stream_name, 
    Controls::Position::Index.example,
    nil,
    reference_list_version
  )
  update_index.()

  test "Nothing is written" do
    refute update_index.writer do
      written?
    end
  end
end
