defmodule Moc.Tests.Counters.PrsCompletedWithNoReviewersTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsCompletedWithNoReviewers
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is not completed" do
    input = %Type.Input{
      status: :open,
      created_by_id: 1,
      reviews: []
    }

    assert PrsCompletedWithNoReviewers.count(input, nil) == []
  end

  test "returns an empty list when there are reviewers" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      reviews: [%{vote: 0}]
    }

    assert PrsCompletedWithNoReviewers.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR has no reviewers" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      reviews: []
    }

    assert PrsCompletedWithNoReviewers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
