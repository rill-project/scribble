defmodule Scribble.Level.GetColorTest do
  use AsyncCase

  alias Scribble.Level

  @colors [trace: :red, info: :cyan]

  describe "when level in config" do
    test "returns color set in config" do
      color = Level.get_color(:trace, @colors)

      assert color == :red
    end
  end

  describe "when level missing from config" do
    test "returns nil" do
      color = Level.get_color(:error, @colors)

      assert is_nil(color)
    end
  end
end
