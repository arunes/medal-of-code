defmodule Moc.Tests.Counters.PrsRejectedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsRejected
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      reviews: [],
      created_by_id: 1
    }

    assert PrsRejected.count(input, nil) == []
  end

  test "returns an empty list when there are no rejections" do
    input = %Type.Input{
      reviews: [
        %{vote: 10, reviewer_id: 2},
        %{vote: 5, reviewer_id: 3}
      ],
      created_by_id: 1
    }

    assert PrsRejected.count(input, nil) == []
  end

  test "returns an empty list when the PR is rejected by the author" do
    input = %Type.Input{
      reviews: [
        %{vote: -10, reviewer_id: 1}
      ],
      created_by_id: 1
    }

    assert PrsRejected.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is rejected by someone else" do
    input = %Type.Input{
      reviews: [
        %{vote: -10, reviewer_id: 2}
      ],
      created_by_id: 1
    }

    assert PrsRejected.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when there are multiple rejections by different people" do
    input = %Type.Input{
      reviews: [
        %{vote: -10, reviewer_id: 2},
        %{vote: -10, reviewer_id: 3}
      ],
      created_by_id: 1
    }

    assert PrsRejected.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1}
           ]
  end
end
