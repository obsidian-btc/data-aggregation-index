require_relative '../../automated_init'

context "Updating index upon a reference being added" do
  reference_list_version = Controls::Position::ReferenceList.example
  reference_added = Controls::ReferenceList::Messages::Added.example reference_list_version
  category = Controls::StreamName::Category.example
  index_stream_name = Controls::StreamName::Index.example

  update_index = ReferenceList::UpdateIndex.new reference_added, category, reference_list_version
  update_index.clock.now = Controls::Time::Raw.example
  update_index.get_positions.set(
    index_stream_name, 
    Controls::Position::Index.example,
    nil,
    Controls::Position::ReferenceList::Previous.example
  )
  update_index.()

  test "Update started is written to index stream" do
    update_started = Controls::Messages::UpdateStarted::AddReference.example reference_list_version
    index_stream_name = Controls::StreamName::Index.example

    assert update_index.write do
      written? do |msg, stream_name|
        msg == update_started && stream_name == index_stream_name
      end
    end
  end

  test "Expected version is set" do
    assert update_index.write do
      written? do |_, _, expected_version|
        expected_version == Controls::Position::Index.example
      end
    end
  end
end
