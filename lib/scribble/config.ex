defmodule Scribble.Config do
  @moduledoc false

  def defaults do
    [
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
    ]
  end

  def get, do: Keyword.merge(defaults(), Application.get_all_env(:scribble))
  def get(key), do: get(key, nil)
  def get(key, default), do: Keyword.get(get(), key) || default

  def put(key, value) do
    Application.put_env(:scribble, key, value)
  end

  def put(config) do
    Enum.each(config, fn {key, value} ->
      put(key, value)
    end)
  end
end
