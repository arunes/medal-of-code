defmodule Moc.Tests.Counters.PrsWithAtLeast5ReviewersTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsWithAtLeast5Reviewers
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are less than 5 reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: Enum.map(1..4, fn i -> %{id: i} end)
    }

    assert PrsWithAtLeast5Reviewers.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there are exactly 5 reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: Enum.map(1..5, fn i -> %{id: i} end)
    }

    assert PrsWithAtLeast5Reviewers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when there are more than 5 reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: Enum.map(1..6, fn i -> %{id: i} end)
    }

    assert PrsWithAtLeast5Reviewers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: []
    }

    assert PrsWithAtLeast5Reviewers.count(input, nil) == []
  end
end
