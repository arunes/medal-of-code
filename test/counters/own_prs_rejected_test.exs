defmodule Moc.Tests.Counters.OwnPRsRejectedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.OwnPRsRejected
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: []
    }

    assert OwnPRsRejected.count(input, nil) == []
  end

  test "returns an empty list when there are no rejections" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 0, reviewer_id: 1},
        %{vote: 5, reviewer_id: 1},
        %{vote: 10, reviewer_id: 1}
      ]
    }

    assert OwnPRsRejected.count(input, nil) == []
  end

  test "returns an empty list when the rejections are from other users" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: -5, reviewer_id: 2},
        %{vote: -10, reviewer_id: 3}
      ]
    }

    assert OwnPRsRejected.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is rejected by the author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: -10, reviewer_id: 1}
      ]
    }

    assert OwnPRsRejected.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the PR is waiting for author by the author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: -5, reviewer_id: 1}
      ]
    }

    assert OwnPRsRejected.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when the PR is rejected multiple times by the author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: -10, reviewer_id: 1},
        %{vote: -5, reviewer_id: 1}
      ]
    }

    assert OwnPRsRejected.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 1, count: 1}
           ]
  end
end
