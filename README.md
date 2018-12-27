# Scribble

Thin wrapper around Elixir `Logger`, providing configurable logging
levels and tagging support

## Installation

The package can be installed by adding `scribble` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scribble, "~> 0.1.2"}
  ]
end
```

Then, ensure `:logger` uses `Scribble` as backend:

```elixir
config :logger, backends: [Scribble]
```

The docs can
be found at [https://hexdocs.pm/scribble](https://hexdocs.pm/scribble).

## Usage

Supports the same arguments as `Logger.log` and the macros `debug`,
`info`, `warn`, `error`.

Available levels are:

- `trace`
- `debug`
- `info`
- `warn`
- `error`
- `fatal`

Available functions are:

- `log`
- `trace`
- `debug`
- `info`
- `warn`
- `error`
- `fatal`

All the functions can be invoked with the following arguments:

- `debug(metadata, fn_or_text)`
- `debug(fn_or_text, metadata)`
- `debug(fn_or_text)`
- `debug([do: block])`
- `debug(metadata, [do: block])`

`log` behaves the same way but has an additional argument at the
beginning of the signature which is the level as an atom.

```elixir
require Scribble

Scribble.trace do
  "one"
end

Scribble.debug tag: :hello, tags: [:bar, :baz] do
  "two"
end

Scribble.info tags: [:world] do
  "three"
end

Scribble.warn([tag: :warntime], fn ->
  "three"
end)

Scribble.error(
  fn -> "four" end,
  tags: [:two, :tags]
)

Scribble.fatal tag: [:end] do
  "five"
end

Scribble.log(:fatal, "six")
```

## Configuration

Default Scribble configuration is the following:

```elixir
config :scribble,
  device: :standard_error,
  levels: [:trace, :debug, :info, :warn, :error, :fatal],
  # Used for logger compile_time_purge, converts scribble levels to
  # Logger levels
  logger_levels: [trace: :debug, fatal: :error],
  # Used to align levels in text
  levelpads: [info: " ", warn: " "],
  colors: [
    trace: :normal,
    debug: :white,
    info: :cyan,
    warn: :yellow,
    error: :green,
    fatal: :red
  ]
```
