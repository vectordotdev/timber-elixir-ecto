defmodule Timber.Ecto do
  @moduledoc """
  Timber integration for Ecto.

  Timber can hook into Ecto's Telemetry events to gather information about queries
  including the text of the query and the time it took to execute. This
  information is then logged as a `Timber.Events.SQLQueryEvent`.

  To install Timber's Ecto event collector, you will need to modify the
  application configuration on a per-repository basis. Each repository has to
  have the Timber handler attached. The best place to do it is in your
  application's `start` callback. It is important to note that the first
  argument must be unique, and the second is based on Ecto's default
  Telemetry event prefix.  More information can be found in the docs
  for `Ecto.Repo`.

  ```elixir
  # lib/my_app/application.ex
  def start(_type, _args) do
    # ...
    :ok = :telemetry.attach(
      "timber-ecto-query-handler",
      [:my_app, :repo, :query],
      &Timber.Ecto.handle_event/4,
      []
    )
    # ...
    Supervisor.start_link(children, opts)
  end
  ```

  Each repository has a configuration key `:log` that controls whether Ecto
  logs query information. By default, it is enabled. In order to avoid duplicate
  logging, you will want to make sure it is set to false.

  ```elixir
  config :my_app, MyApp.Repo,
    log: false
  ```

  By default, queries are logged at the `:debug` level. If you want to use a
  different level, the `:log_level` option can be passed to the
  `Telemetry.attach` call:

  ```elixir
  :ok = :telemetry.attach(
    "timber-ecto-query-handler",
    [:my_app, :repo, :query],
    &Timber.Ecto.handle_event/4,
    [log_level: :info]
    )
  ```

  ### Timing

  The time reported in the event is the amount of time the query took to execute
  on the database, as measured by Ecto. It does not include the time that the
  query spent in the pool's queue or the time spent decoding the response from
  the database.

  ### Log only slow queries

  If your queries are noisy you can specify a threshold that must be crossed in
  order for the query to be logged:

  ```elixir
  :ok = :telemetry.attach(
    "timber-ecto-query-handler",
    [:my_app, :repo, :query],
    &Timber.Ecto.handle_event/4,
    [query_time_ms_threshold: 2_000]
    )
  ```
  ```

  In the above example, only queries that exceed 2 seconds in execution time
  will be logged.
  """

  require Logger

  def handle_event([_app, _repo, :query], _value, metadata, config) do
    query_time_ms_threshold = Keyword.get(config, :query_time_ms_threshold, 0)
    log_level = Keyword.get(config, :log_level, :debug)

    with {:ok, time} when is_integer(time) <- Map.fetch(metadata, :query_time),
         {:ok, query} <- Map.fetch(metadata, :query),
         duration_ms <- System.convert_time_unit(time, :native, :millisecond),
         true <- duration_ms >= query_time_ms_threshold do
      event = %{
        sql_query_executed: %{
          sql: query,
          duration_ms: duration_ms
        }
      }

      message = ["Processed ", query, " in ", to_string(duration_ms), "ms"]

      Logger.log(log_level, message, event: event)
    end

    :ok
  end
end
