defmodule Moc.Tests.Counters.RequiredReviewersAddedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.RequiredReviewersAdded
  alias Moc.Scoring.Counters.Type

  test "returns the correct count when there are no required reviewers" do
    reviews = [
      %{is_required: false},
      %{is_required: false}
    ]

    input = %Type.Input{
      created_by_id: 1,
      reviews: reviews
    }

    assert RequiredReviewersAdded.count(input, nil) == [
             %{contributor_id: 1, count: 0}
           ]
  end

  test "returns the correct count when there are required reviewers" do
    reviews = [
      %{is_required: true},
      %{is_required: false},
      %{is_required: true}
    ]

    input = %Type.Input{
      created_by_id: 1,
      reviews: reviews
    }

    assert RequiredReviewersAdded.count(input, nil) == [
             %{contributor_id: 1, count: 2}
           ]
  end

  test "returns the correct count when all reviewers are required" do
    reviews = [
      %{is_required: true},
      %{is_required: true},
      %{is_required: true}
    ]

    input = %Type.Input{
      created_by_id: 1,
      reviews: reviews
    }

    assert RequiredReviewersAdded.count(input, nil) == [
             %{contributor_id: 1, count: 3}
           ]
  end

  test "returns the correct count when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: []
    }

    assert RequiredReviewersAdded.count(input, nil) == [
             %{contributor_id: 1, count: 0}
           ]
  end
end
