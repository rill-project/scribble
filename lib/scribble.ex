defmodule Scribble do
  @moduledoc "Backend for Elixir Logger"

  alias Scribble.Backend
  require Logger

  @behaviour :gen_event

  defstruct buffer: [],
            buffer_size: 0,
            colors: nil,
            device: nil,
            format: nil,
            level: nil,
            max_buffer: nil,
            output: nil,
            ref: nil

  @doc false
  defdelegate init(state), to: Backend
  @doc false
  defdelegate handle_call(msg, state), to: Backend
  @doc false
  defdelegate handle_event(msg, state), to: Backend
  @doc false
  defdelegate handle_info(msg, state), to: Backend
  @doc false
  defdelegate code_change(old_vsn, state, extra), to: Backend
  @doc false
  defdelegate terminate(reason, state), to: Backend

  @type level :: atom()
  @type chardata_or_fun ::
          String.t() | (() -> String.t() | {String.t(), keyword()})
  @type written :: :ok | term()
  @type metadata :: keyword()

  defguardp is_log(chardata_or_fun) when not is_list(chardata_or_fun)

  @spec log(level :: level(), chardata_or_fun :: chardata_or_fun()) :: written()
  defmacro log(level, chardata_or_fun)
           when is_atom(level) and is_log(chardata_or_fun) do
    quote do
      unquote(__MODULE__).log(
        unquote(level),
        unquote(chardata_or_fun),
        []
      )
    end
  end

  @spec log(level :: level(), do: term()) :: written()
  defmacro log(level, do: block) when is_atom(level) do
    quote do
      unquote(__MODULE__).log(
        unquote(level),
        [],
        do: unquote(block)
      )
    end
  end

  @spec log(level :: level(), metadata :: metadata(), do: term()) :: written()
  defmacro log(level, metadata, do: block)
           when is_atom(level) and is_list(metadata) do
    quote do
      unquote(__MODULE__).log(
        unquote(level),
        fn -> unquote(block) end,
        unquote(metadata)
      )
    end
  end

  @spec log(
          level :: level(),
          metadata :: metadata(),
          chardata_or_fun :: chardata_or_fun()
        ) :: written()
  defmacro log(level, metadata, chardata_or_fun)
           when is_atom(level) and is_list(metadata) and is_log(chardata_or_fun) do
    quote do
      unquote(__MODULE__).log(
        unquote(level),
        unquote(metadata),
        unquote(chardata_or_fun)
      )
    end
  end

  @spec log(
          level :: level(),
          chardata_or_fun :: chardata_or_fun(),
          metadata :: metadata()
        ) :: written()
  defmacro log(level, chardata_or_fun, metadata)
           when is_atom(level) and is_list(metadata) and is_log(chardata_or_fun) do
    tag = metadata[:tag]
    tags = metadata[:tags] || []
    tags = if is_nil(tag), do: tags, else: [tag | tags]
    metadata = Keyword.delete(metadata, :tag)
    metadata = Keyword.put(metadata, :tags, tags)
    logger_level = Scribble.Level.get_logger_level(level)

    quote bind_quoted: [
            logger_level: logger_level,
            level: level,
            chardata_or_fun: chardata_or_fun,
            metadata: metadata
          ] do
      require Logger

      Logger.log(
        logger_level,
        fn ->
          out =
            if is_function(chardata_or_fun) do
              chardata_or_fun.()
            else
              chardata_or_fun
            end

          out =
            if is_tuple(out) do
              out
            else
              {out, metadata}
            end

          {msg, md} = out
          md = Keyword.merge(md, metadata)
          level = md[:level] || level
          md = Keyword.put(md, :level, level)
          {msg, md}
        end,
        metadata
      )
    end
  end

  for level <- Application.get_env(:logger, Scribble)[:levels] do
    @spec unquote(level)(do: term()) :: written()
    defmacro unquote(level)(do: block) do
      level = unquote(level)

      quote do
        unquote(__MODULE__).log(
          unquote(level),
          [],
          do: unquote(block)
        )
      end
    end

    @spec unquote(level)(chardata_or_fun :: chardata_or_fun()) :: written()
    defmacro unquote(level)(chardata_or_fun) when is_log(chardata_or_fun) do
      level = unquote(level)

      quote do
        unquote(__MODULE__).log(
          unquote(level),
          unquote(chardata_or_fun),
          []
        )
      end
    end

    @spec unquote(level)(metadata :: metadata(), do: term()) :: written()
    defmacro unquote(level)(metadata, do: block) when is_list(metadata) do
      level = unquote(level)

      quote do
        unquote(__MODULE__).log(
          unquote(level),
          unquote(metadata),
          do: unquote(block)
        )
      end
    end

    @spec unquote(level)(
            metadata :: metadata(),
            chardata_or_fun :: chardata_or_fun()
          ) :: written()
    defmacro unquote(level)(metadata, chardata_or_fun)
             when is_log(chardata_or_fun) and is_list(metadata) do
      level = unquote(level)

      quote do
        unquote(__MODULE__).log(
          unquote(level),
          unquote(chardata_or_fun),
          unquote(metadata)
        )
      end
    end

    @spec unquote(level)(
            chardata_or_fun :: chardata_or_fun(),
            metadata :: metadata()
          ) :: written()
    defmacro unquote(level)(chardata_or_fun, metadata)
             when is_log(chardata_or_fun) and is_list(metadata) do
      level = unquote(level)

      quote do
        unquote(__MODULE__).log(
          unquote(level),
          unquote(chardata_or_fun),
          unquote(metadata)
        )
      end
    end
  end
end
