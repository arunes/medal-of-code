defmodule Moc.Tests.Counters.PrsWithAtLeast10ReviewersTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsWithAtLeast10Reviewers
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are less than 10 reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: Enum.map(1..9, fn i -> %{id: i} end)
    }

    assert PrsWithAtLeast10Reviewers.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there are exactly 10 reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: Enum.map(1..10, fn i -> %{id: i} end)
    }

    assert PrsWithAtLeast10Reviewers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when there are more than 10 reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: Enum.map(1..11, fn i -> %{id: i} end)
    }

    assert PrsWithAtLeast10Reviewers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: []
    }

    assert PrsWithAtLeast10Reviewers.count(input, nil) == []
  end
end
