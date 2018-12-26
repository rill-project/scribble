use Mix.Config

config :logger, Scribble,
  device: :standard_error,
  levels: [:trace, :debug, :info, :warn, :error, :fatal],
  logger_levels: [trace: :debug, fatal: :error],
  levelpads: [info: " ", warn: " "],
  colors: [
    trace: :normal,
    debug: :white,
    info: :cyan,
    warn: :yellow,
    error: :green,
    fatal: :red
  ]

config :logger,
  backends: [Scribble],
  utc_log: true,
  compile_time_purge_matching: [
    [level_lower_than: :debug]
  ]

import_config Path.expand("./environment/#{Mix.env()}.exs", __DIR__)

if File.exists?(Path.expand("./environment/#{Mix.env()}.secret.exs", __DIR__)) do
  import_config Path.expand("./environment/#{Mix.env()}.secret.exs", __DIR__)
end
