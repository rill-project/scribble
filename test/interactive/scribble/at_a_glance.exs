defmodule Hello do
  require Scribble

  def world do
    Scribble.trace do
      :timer.sleep(1000)
      IO.puts("foo")
      "asd"
    end

    Scribble.debug tag: :hello, tags: [:bar, :baz] do
      :timer.sleep(1000)
      IO.puts("bar")
      "hello"
    end

    Scribble.info tags: [:world] do
      "world"
    end

    Scribble.warn([tag: :warntime], fn ->
      "warn time"
    end)

    Scribble.error(
      fn -> "error message" end,
      tags: [:two, :tags]
    )

    Scribble.fatal tag: [:end] do
      "dev"
    end

    Scribble.log(:fatal, "end")
  end
end

defmodule DefaultTags do
  require Scribble

  @scribble tag: :mydefaulttag, include_tags: true
  def show do
    Scribble.fatal tag: :special do
      "special"
    end
  end

  @scribble tags: [:special1, :special2], include_tags: true
  def show2 do
    Scribble.fatal do
      "special"
    end
  end
end

defmodule Run do
  def run do
    Hello.world()
    DefaultTags.show()
    DefaultTags.show2()
  end
end

Run.run()
