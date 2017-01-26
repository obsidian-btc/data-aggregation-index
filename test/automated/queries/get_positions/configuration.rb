require_relative '../../automated_init'

context "Get positions query is configured" do
  context "Session is specified" do
    session = EventSource::EventStore::HTTP::Session.build

    get_positions = Queries::GetPositions.build session: session

    test "Session is set on instance" do
      assert get_positions.session == session
    end

    test "Session is used when building get last" do
      get_last = get_positions.build_get_last

      assert get_last do
        session? session
      end
    end
  end
end
