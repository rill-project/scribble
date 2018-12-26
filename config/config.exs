use Mix.Config

config :scribble,
  levels: [:trace, :debug, :info, :warn, :error, :fatal]

config :logger,
  backends: [:console],
  utc_log: true,
  compile_time_purge_matching: [
    [level_lower_than: :debug]
  ]

config :logger, :console,
  format: {Scribble.Logger, :format},
  device: :standard_error,
  metadata: :all

import_config "./environment/#{Mix.env()}.exs"

if File.exists?(Path.expand("./environment/#{Mix.env()}.secret.exs", __DIR__)) do
  import_config "./environment/#{Mix.env()}.secret.exs"
end
