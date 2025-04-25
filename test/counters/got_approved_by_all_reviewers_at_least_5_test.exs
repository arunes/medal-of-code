defmodule Moc.Tests.Counters.GotApprovedByAllReviewersAtLeast5Test do
  use ExUnit.Case

  alias Moc.Scoring.Counters.GotApprovedByAllReviewersAtLeast5
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{created_by_id: 1, reviews: []}
    assert GotApprovedByAllReviewersAtLeast5.count(input, nil) == []
  end

  test "returns an empty list when only review is from the author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{reviewer_id: 1, vote: 10}
      ]
    }

    assert GotApprovedByAllReviewersAtLeast5.count(input, nil) == []
  end

  test "returns an empty list when there are less than 5 positive reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{reviewer_id: 2, vote: 10},
        %{reviewer_id: 3, vote: 5},
        %{reviewer_id: 4, vote: 10}
      ]
    }

    assert GotApprovedByAllReviewersAtLeast5.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there are at least 5 positive reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{reviewer_id: 2, vote: 10},
        %{reviewer_id: 3, vote: 5},
        %{reviewer_id: 4, vote: 10},
        %{reviewer_id: 5, vote: 10},
        %{reviewer_id: 6, vote: 5}
      ]
    }

    assert GotApprovedByAllReviewersAtLeast5.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
