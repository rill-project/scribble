defmodule Scribble.Logger.Formatter.Pretty do
  @moduledoc false

  @spec time(time_tuple :: tuple()) :: String.t()
  def time(time_tuple) do
    {date, {hours, minutes, seconds, micro}} = time_tuple
    time = {hours, minutes, seconds}
    micro = {micro * 1000, 6}

    naive = NaiveDateTime.from_erl!({date, time}, micro)

    NaiveDateTime.to_iso8601(naive)
  end

  @spec level(level :: Scribble.Level.t()) :: String.t()
  def level(level) do
    level
    |> to_string()
    |> String.upcase()
  end

  @spec module(metadata :: {:module, atom()} | {:function, atom()}) ::
          String.t()
  def module(metadata) do
    case {metadata[:module], metadata[:function]} do
      {nil, nil} -> ""
      {nil, function} -> to_string(function)
      {module, nil} -> to_string(module)
      {module, function} -> "#{module}.#{function}"
    end
  end
end
