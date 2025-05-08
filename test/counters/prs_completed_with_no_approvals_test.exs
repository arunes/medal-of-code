defmodule Moc.Tests.Counters.PrsCompletedWithNoApprovalsTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsCompletedWithNoApprovals
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is not completed" do
    input = %Type.Input{
      status: :open,
      created_by_id: 1,
      reviews: []
    }

    assert PrsCompletedWithNoApprovals.count(input, nil) == []
  end

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      reviews: []
    }

    assert PrsCompletedWithNoApprovals.count(input, nil) == []
  end

  test "returns an empty list when there are approvals" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      reviews: [%{vote: 5}, %{vote: 10}]
    }

    assert PrsCompletedWithNoApprovals.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR has no approvals" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      reviews: [%{vote: 0}, %{vote: -5}, %{vote: -10}]
    }

    assert PrsCompletedWithNoApprovals.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
