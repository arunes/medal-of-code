defmodule Moc.Tests.Counters.PrsNotVotedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsNotVoted
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      reviews: []
    }

    assert PrsNotVoted.count(input, nil) == []
  end

  test "returns an empty list when there are no reviews with no vote" do
    input = %Type.Input{
      reviews: [
        %{vote: 10, reviewer_id: 1},
        %{vote: 5, reviewer_id: 2},
        %{vote: -5, reviewer_id: 3},
        %{vote: -10, reviewer_id: 4}
      ]
    }

    assert PrsNotVoted.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there is a review with no vote" do
    input = %Type.Input{
      reviews: [
        %{vote: 0, reviewer_id: 1}
      ]
    }

    assert PrsNotVoted.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when there are multiple reviews with no vote" do
    input = %Type.Input{
      reviews: [
        %{vote: 0, reviewer_id: 1},
        %{vote: 0, reviewer_id: 2}
      ]
    }

    assert PrsNotVoted.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end
end
