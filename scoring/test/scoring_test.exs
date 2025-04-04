defmodule ScoringTest do
  use ExUnit.Case
  doctest Scoring

  test "greets the world" do
    assert Scoring.hello() == :world
  end
end
