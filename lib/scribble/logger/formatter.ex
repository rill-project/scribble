defmodule Scribble.Logger.Formatter do
  @moduledoc false

  alias Scribble.Level
  alias Scribble.Logger.Formatter.Pretty

  defdelegate levelpad(level), to: Level, as: :get_levelpad

  def get_level(level, metadata) do
    metadata[:level] || level
  end

  def format(level, message, time, metadata) do
    level = metadata[:level] || level
    time = Pretty.time(time)
    text_level = Pretty.level(level)
    pad = levelpad(level)

    target =
      case Pretty.module(metadata) do
        "" -> ""
        text -> " #{text}"
      end

    "[#{time}]#{target} #{text_level}: #{pad}#{message}\n"
  rescue
    _ -> "could not format: #{inspect({level, message, metadata})}"
  end
end
