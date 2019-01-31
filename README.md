# 🌲 Timber integration for Ecto

[![ISC License](https://img.shields.io/badge/license-ISC-ff69b4.svg)](https://github.com/timberio/timber-elixir-ecto/blob/master/LICENSE)
[![Hex.pm](https://img.shields.io/hexpm/v/timber_ecto.svg?maxAge=18000=plastic)](https://hex.pm/packages/timber_ecto)
[![Documentation](https://img.shields.io/badge/hexdocs-latest-blue.svg)](https://hexdocs.pm/timber_ecto/readme.html)
[![Build Status](https://travis-ci.org/timberio/timber-elixir-ecto.svg?branch=master)](https://travis-ci.org/timberio/timber-elixir-ecto)

The Timber Ecto library provides enhanced logging for your Ecto queries.

Need Ecto 2.x support? Ecto 2 support is maintained on the [v1.x branch](https://github.com/timberio/timber-elixir-ecto/tree/v1.x).

## Installation

Ensure that you have both `:timber` (version 3.0.0 or later) and `:timber_ecto` listed
as dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:timber, "~> 3.0"},
    {:timber_ecto, "~> 2.0"}
  ]
end
```

Then run `mix deps.get`.

You'll need to add a configuration line for every Ecto Repo. For example, if you
have the application `:my_app` and the Ecto Repo `MyApp.Repo`, the configuration
in `config/config.exs` would look like this:

```elixir
use Mix.Config

config :my_app, MyApp.Repo,
  log: false
```

You'll also have to attach Timber's Telemetry event handler in your Application's `start` callback:

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

For more information, see the documentation for the
[Timber.Ecto](https://hexdocs.pm/timber_ecto/Timber.Ecto.html) module.

### Notes for Umbrella Applications

When integrating Timber with Ecto for an umbrella application, the
`:timber_ecto` library needs to be a dependency for every application that
defines an Ecto Repo.

## Advanced

Logging SQL queries can be useful but noisy. To reduce the volume of SQL queries
you can limit your logging to queries that surpass an execution time threshold:

```elixir
:ok = Telemetry.attach(
  "timber-ecto-query-handler",
  [:my_app, :repo, :query],
  Timber.Ecto,
  :handle_event,
  [query_time_ms_threshold: 2_000]
  )
```

In the above example, only queries that exceed 2 seconds in execution
time will be logged.

## License

This project is licensed under the ISC license. See the file `LICENSE` for the
full text.
