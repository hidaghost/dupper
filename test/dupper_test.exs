defmodule DupperTest do
  use ExUnit.Case
  doctest Dupper

  test "greets the world" do
    assert Dupper.hello() == :world
  end
end
