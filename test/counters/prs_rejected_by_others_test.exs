defmodule Moc.Tests.Counters.PrsRejectedByOthersTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsRejectedByOthers
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      reviews: [],
      created_by_id: 1
    }

    assert PrsRejectedByOthers.count(input, nil) == []
  end

  test "returns an empty list when there are no rejections by others" do
    input = %Type.Input{
      reviews: [
        %{vote: 10, reviewer_id: 2},
        %{vote: 5, reviewer_id: 3}
      ],
      created_by_id: 1
    }

    assert PrsRejectedByOthers.count(input, nil) == []
  end

  test "returns an empty list when the PR is rejected by the author" do
    input = %Type.Input{
      reviews: [
        %{vote: -10, reviewer_id: 1}
      ],
      created_by_id: 1
    }

    assert PrsRejectedByOthers.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is rejected by someone else" do
    input = %Type.Input{
      reviews: [
        %{vote: -10, reviewer_id: 2}
      ],
      created_by_id: 1
    }

    assert PrsRejectedByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when there are multiple reviews and one rejection by someone else" do
    input = %Type.Input{
      reviews: [
        %{vote: 10, reviewer_id: 2},
        %{vote: -10, reviewer_id: 3}
      ],
      created_by_id: 1
    }

    assert PrsRejectedByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
