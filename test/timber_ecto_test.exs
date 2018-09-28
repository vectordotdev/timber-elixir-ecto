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
          Timber.Ecto.log(%{query: query, query_time: timer}, :info)
        end)

      assert log =~ "Processed SELECT * FROM table in #{timer}ms"
    end

    test "query_time is nil" do
      query = "SELECT * FROM table"

      log =
        capture_log(fn ->
          Timber.Ecto.log(%{query: query, query_time: nil}, :info)
        end)

      assert log == ""
    end
  end
end
