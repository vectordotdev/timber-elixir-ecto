defmodule Timber.EctoTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  require Logger

  describe "Timber.Ecto.log/2" do
    test "exceeds the query threshold" do
      query = "SELECT * FROM table"
      timer = 0

      log =
        capture_log(fn ->
          Timber.Ecto.handle_event(
            [:app, :repo, :query],
            1_000,
            %{query: query, query_time: timer, params: []},
            []
          )
        end)

      assert log =~ "Processed SELECT * FROM table in #{timer}ms"
    end

    test "prints params" do
      query = "SELECT * FROM table WHERE id = $1"
      timer = 0

      log =
        capture_log(fn ->
          Timber.Ecto.handle_event(
            [:app, :repo, :query],
            1_000,
            %{query: query, query_time: timer, params: [42]},
            []
          )
        end)

      assert log =~ "Processed SELECT * FROM table WHERE id = $1 in 0ms with args [42]"
    end

    test "query_time is nil" do
      query = "SELECT * FROM table"

      log =
        capture_log(fn ->
          Timber.Ecto.handle_event(
            [:app, :repo, :query],
            nil,
            %{query: query, query_time: nil},
            []
          )
        end)

      assert log == ""
    end
  end
end
