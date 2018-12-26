defmodule Scribble.Level do
  @type t :: atom()
  @type color :: atom()
  @type comparison :: :lt | :gt | :eq

  @spec levels() :: [t()]
  def levels do
    Application.get_env(:scribble, :levels)
  end

  @spec get_color(level :: t()) :: color()
  def get_color(level) when is_atom(level) do
    # colors
    :cyan
  end

  @spec to_integer(level :: t()) :: non_neg_integer() | nil
  def to_integer(level) when is_atom(level) do
    levels = levels()
    Enum.find_index(levels, fn left -> left == level end)
  end

  @spec to_integer!(level :: t()) :: non_neg_integer()
  def to_integer!(level) when is_atom(level) do
    num_value = to_integer(level)

    if is_nil(num_value) do
      raise ArgumentError, message: "Invalid level: #{inspect(level)}"
    else
      num_value
    end
  end

  @spec cmp(left :: t(), right :: t()) :: comparison() | {:error, String.t()}
  def cmp(left, right) when is_atom(left) and is_atom(right) do
    left = to_integer(left)
    right = to_integer(right)

    cond do
      is_nil(left) ->
        {:error, "Invalid left level: #{inspect(left)}"}

      is_nil(right) ->
        {:error, "Invalid right level: #{inspect(right)}"}

      left == right ->
        :eq

      left < right ->
        :lt

      left > right ->
        :gt

      true ->
        {:error, "Unknown comparison: #{inspect(left)} cmp #{inspect(right)}"}
    end
  end

  @spec cmp!(left :: t(), right :: t()) :: comparison()
  def cmp!(left, right) when is_atom(left) and is_atom(right) do
    case cmp(left, right) do
      {:error, error} -> raise ArgumentError, message: to_string(error)
      comparison -> comparison
    end
  end
end
