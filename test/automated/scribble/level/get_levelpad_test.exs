defmodule Scribble.Level.GetLevelpadTest do
  use AsyncCase

  alias Scribble.Level

  @levelpads [info: " ", warn: " "]

  describe "when level in config" do
    test "returns levelpad set in config" do
      levelpad = Level.get_levelpad(:info, @levelpads)

      assert levelpad == " "
    end
  end

  describe "when level missing from config" do
    test "returns empty string" do
      levelpad = Level.get_levelpad(:trace, @levelpads)

      assert levelpad == ""
    end
  end
end
