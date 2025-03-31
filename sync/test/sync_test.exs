defmodule Moc.SyncTest do
  use ExUnit.Case
  doctest Moc.Sync

  test "greets the world" do
    assert Sync.hello() == :world
  end
end
