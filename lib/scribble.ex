defmodule Scribble do
  @moduledoc "Backend for Elixir Logger"

  require Logger
  use Scribble.Backend

  @type level :: atom()
  @type chardata_or_fun ::
          String.t() | (() -> String.t() | {String.t(), keyword()})
  @type metadata :: keyword()
  @type log_output :: :ok | term()

  defguardp is_log(chardata_or_fun) when not is_list(chardata_or_fun)

  @spec log(level :: level(), chardata_or_fun :: chardata_or_fun()) ::
          log_output()
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

  @spec log(level :: level(), do: term()) :: log_output()
  defmacro log(level, do: block) when is_atom(level) do
    quote do
      unquote(__MODULE__).log(
        unquote(level),
        [],
        do: unquote(block)
      )
    end
  end

  @spec log(level :: level(), metadata :: metadata(), do: term()) ::
          log_output()
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
        ) :: log_output()
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
        ) :: log_output()
  defmacro log(level, chardata_or_fun, metadata)
           when is_atom(level) and is_list(metadata) and is_log(chardata_or_fun) do
    tag = metadata[:tag]
    tags = metadata[:tags] || []
    tags = if is_nil(tag), do: tags, else: [tag | tags]
    metadata = Keyword.delete(metadata, :tag)
    metadata = Keyword.put(metadata, :tags, tags)
    logger_level = Scribble.Level.get_logger_level(level)
    opts = Module.get_attribute(__CALLER__.module, :scribble) || []

    quote do
      require Logger

      opts = unquote(opts)
      default_tags = opts[:tags] || []

      default_tags =
        case opts[:tag] do
          nil -> default_tags
          tag -> [tag | default_tags]
        end

      metadata = unquote(metadata)
      tags = Keyword.get(metadata, :tags, [])
      tags = default_tags ++ tags

      metadata =
        metadata
        |> Keyword.put(:include_tags, opts[:include_tags] || false)
        |> Keyword.put(:tags, tags)

      Logger.unquote(logger_level)(
        fn ->
          level = unquote(level)
          chardata_or_fun = unquote(chardata_or_fun)

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

  for level <- Scribble.Config.get(:levels) do
    @spec unquote(level)(do: term()) :: log_output()
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

    @spec unquote(level)(chardata_or_fun :: chardata_or_fun()) :: log_output()
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

    @spec unquote(level)(metadata :: metadata(), do: term()) :: log_output()
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
          ) :: log_output()
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
          ) :: log_output()
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
