defmodule Moc.Tests.Counters.OwnPRsApprovedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.OwnPRsApproved
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: []
    }

    assert OwnPRsApproved.count(input, nil) == []
  end

  test "returns an empty list when there are no approvals" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 0, reviewer_id: 1},
        %{vote: -5, reviewer_id: 1},
        %{vote: -10, reviewer_id: 1}
      ]
    }

    assert OwnPRsApproved.count(input, nil) == []
  end

  test "returns an empty list when the approvals are from other users" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 10, reviewer_id: 2},
        %{vote: 5, reviewer_id: 3}
      ]
    }

    assert OwnPRsApproved.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is approved by the author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 10, reviewer_id: 1}
      ]
    }

    assert OwnPRsApproved.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the PR is approved with suggestions by the author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 5, reviewer_id: 1}
      ]
    }

    assert OwnPRsApproved.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when the PR is approved multiple times by the author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 10, reviewer_id: 1},
        %{vote: 5, reviewer_id: 1}
      ]
    }

    assert OwnPRsApproved.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 1, count: 1}
           ]
  end
end
