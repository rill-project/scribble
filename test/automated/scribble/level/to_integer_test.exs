defmodule Scribble.Level.ToIntegerTest do
  use AsyncCase

  alias Scribble.Level

  describe "when level exists" do
    test "to_integer converts level to index number" do
      level = Level.to_integer(:trace)

      assert level == 0
    end

    test "to_integer! converts level to index number" do
      level = Level.to_integer!(:trace)

      assert level == 0
    end
  end

  describe "when level is not valid" do
    test "to_integer returns nil" do
      level = Level.to_integer(:foo)

      assert is_nil(level)
    end

    test "to_integer! raises ArgumentError" do
      assert_raise ArgumentError, fn -> Level.to_integer!(:foo) end
    end
  end
end
