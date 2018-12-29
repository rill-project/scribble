# Scribble

Thin wrapper around Elixir `Logger`, providing configurable logging
levels and tagging support

## Installation

The package can be installed by adding `scribble` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scribble, ">= 0.0.0"}
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

# The single tag will be prepended to `:tags`, so tags: [:hello, :bar, :baz]
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

It's possible to set default tags through `@scribble` attribute, which can be
set multiple times to change the configuration (it doesn't accumulate):

```elixir
defmodule Foo do
  @scribble tag: :foo
  def test1 do
    Scribble.info tag: :bar do
      "message"
    end
    # the message will have `tags: [:foo, :bar]`
  end

  # Tags can also be printed upon request
  @scribble tag: bar, include_tags: true
  def test2 do
    Scribble.info tag: :baz do
      "message"
    end
    # => (bar, baz) message
  end
end
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
