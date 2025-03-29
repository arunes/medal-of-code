defmodule MocDataTest do
  use ExUnit.Case
  doctest MocData

  test "greets the world" do
    assert MocData.hello() == :world
  end
end
