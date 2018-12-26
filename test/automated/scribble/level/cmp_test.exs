defmodule Scribble.Level.CmpTest do
  use AsyncCase

  alias Scribble.Level

  describe "when left less than right" do
    test "returns :lt" do
      comparison = Level.cmp(:debug, :error)

      assert comparison == :lt
    end
  end

  describe "when left equals right" do
    test "returns :eq" do
      comparison = Level.cmp(:debug, :debug)

      assert comparison == :eq
    end
  end

  describe "when left greater than right" do
    test "returns :gt" do
      comparison = Level.cmp(:error, :debug)

      assert comparison == :gt
    end
  end

  describe "when left doesn't exist" do
    test "cmp returns {:error, String.t()}" do
      {:error, _} = Level.cmp(:foo, :error)
    end

    test "cmp! raises ArgumentError" do
      assert_raise ArgumentError, fn -> Level.cmp!(:foo, :error) end
    end
  end

  describe "when right doesn't exist" do
    test "cmp returns {:error, String.t()}" do
      {:error, _} = Level.cmp(:error, :foo)
    end

    test "cmp! raises ArgumentError" do
      assert_raise ArgumentError, fn -> Level.cmp!(:error, :foo) end
    end
  end
end
