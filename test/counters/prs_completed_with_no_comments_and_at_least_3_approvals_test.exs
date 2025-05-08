defmodule Moc.Tests.Counters.PrsCompletedWithNoCommentsAndAtLeast3ApprovalsTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsCompletedWithNoCommentsAndAtLeast3Approvals
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is not completed" do
    input = %Type.Input{
      status: :open,
      created_by_id: 1,
      comments: [],
      reviews: [%{vote: 10}, %{vote: 10}, %{vote: 10}]
    }

    assert PrsCompletedWithNoCommentsAndAtLeast3Approvals.count(input, nil) == []
  end

  test "returns an empty list when there are comments" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      comments: [%{comment_type: :text}],
      reviews: [%{vote: 10}, %{vote: 10}, %{vote: 10}]
    }

    assert PrsCompletedWithNoCommentsAndAtLeast3Approvals.count(input, nil) == []
  end

  test "returns an empty list when there are less than 3 approvals" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      comments: [],
      reviews: [%{vote: 10}, %{vote: 10}]
    }

    assert PrsCompletedWithNoCommentsAndAtLeast3Approvals.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR has no comments and at least 3 approvals" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      comments: [],
      reviews: [%{vote: 10}, %{vote: 10}, %{vote: 10}]
    }

    assert PrsCompletedWithNoCommentsAndAtLeast3Approvals.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
