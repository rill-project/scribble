defmodule Scribble.Logger do
  require Logger

  defmacro log(level, chardata_or_fun, metadata \\ []) do
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
          md = Keyword.merge(metadata, md)
          level = md[:level] || level
          md = Keyword.put(md, :level, level)
          {msg, md}
        end,
        metadata
      )
    end
  end

  for level <- Application.get_env(:logger, Scribble)[:levels] do
    defmacro unquote(level)(chardata_or_fun, metadata \\ []) do
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
