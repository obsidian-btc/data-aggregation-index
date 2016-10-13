require_relative '../bench_init'

context "Category is specified on index" do
  category = Controls::Index.category

  test "Category query returns specified category" do
    assert category == Controls::StreamName::Category.example
  end
end
