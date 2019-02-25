# Changelog

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic
Versioning](http://semver.org/spec/v2.0.0.html).

This covers changes for versions 2.0 and higher. The changelog for 1.x releases
can be found in the [v1.x branch](https://github.com/timberio/timber-elixir-ecto/blob/v1.x/CHANGELOG.md).


## [Unreleased]

### Changed

## [2.1.0] - 2019-02-25

### Changed
  - Removed use of Timber-specific custom context and events in favor of simple maps
  - Fix Elixir 1.8 warnings
  - `sql_query` events are now called `sql_query_executed` events to follow the recommended
    Timber event naming scheme

## [2.0.0] - 2018-12-21

### Changed

  - Support Ecto 3

### Removed

  - Removed support for Ecto 2


[Unreleased]: https://github.com/timberio/timber-elixir-ecto/compare/v2.1.0...HEAD
[2.0.0]: https://github.com/timberio/timber-elixir-ecto/compare/v1.0.0...v2.0.0
[2.1.0]: https://github.com/timberio/timber-elixir-ecto/compare/v2.0.0...v2.1.0
