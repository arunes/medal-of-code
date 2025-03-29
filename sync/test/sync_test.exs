defmodule SyncTest do
  use ExUnit.Case
  doctest Sync

  test "greets the world" do
    assert Sync.hello() == :world
  end
end
