require_relative '../../automated_init'

context "Get positions query is configured" do
  context "Session is specified" do
    session = Object.new

    get_positions = Queries::GetPositions.build session: session

    test "Session is set on instance" do
      assert get_positions.session == session
    end

    test "Session is used when building readers" do
      stream_name = Controls::StreamName::Category.example

      reader = get_positions.build_reader stream_name

      assert reader do
        session? session
      end
    end
  end
end
