defmodule Moc.Tests.Counters.PrsApprovedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsApproved
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: []
    }

    assert PrsApproved.count(input, nil) == []
  end

  test "returns an empty list when there are no approvals" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 0, reviewer_id: 2},
        %{vote: 5, reviewer_id: 3},
        %{vote: -5, reviewer_id: 4},
        %{vote: -10, reviewer_id: 5}
      ]
    }

    assert PrsApproved.count(input, nil) == []
  end

  test "returns an empty list when the approval is from the PR author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 10, reviewer_id: 1}
      ]
    }

    assert PrsApproved.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is approved" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 10, reviewer_id: 2}
      ]
    }

    assert PrsApproved.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when the PR is approved by multiple reviewers" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 10, reviewer_id: 2},
        %{vote: 10, reviewer_id: 3}
      ]
    }

    assert PrsApproved.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1}
           ]
  end
end
