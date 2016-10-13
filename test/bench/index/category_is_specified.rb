require_relative '../bench_init'

context "Category is specified on index" do
  index_mod = Module.new do
    include DataAggregation::Index

    category :some_index
  end

  context "Category is queried" do
    category = index_mod.category

    test do
      assert category == 'someIndex'
    end
  end
end
