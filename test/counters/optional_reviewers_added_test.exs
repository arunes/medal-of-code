defmodule Moc.Tests.Counters.OptionalReviewersAddedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.OptionalReviewersAdded
  alias Moc.Scoring.Counters.Type

  test "returns a contributor with a count of 0 when there are no optional reviews" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      reviews: [
        %{is_required: true},
        %{is_required: true}
      ]
    }

    assert OptionalReviewersAdded.count(input, nil) == [
             %{contributor_id: "11111111-1111-1111-1111-111111111111", count: 0}
           ]
  end

  test "returns a contributor with a count of 1 when there is 1 optional review" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      reviews: [
        %{is_required: true},
        %{is_required: false}
      ]
    }

    assert OptionalReviewersAdded.count(input, nil) == [
             %{contributor_id: "11111111-1111-1111-1111-111111111111", count: 1}
           ]
  end

  test "returns a contributor with a count of multiple when there are multiple optional reviews" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      reviews: [
        %{is_required: false},
        %{is_required: false},
        %{is_required: true}
      ]
    }

    assert OptionalReviewersAdded.count(input, nil) == [
             %{contributor_id: "11111111-1111-1111-1111-111111111111", count: 2}
           ]
  end

  test "returns a contributor with a count of all reviews when all reviews are optional" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      reviews: [
        %{is_required: false},
        %{is_required: false},
        %{is_required: false}
      ]
    }

    assert OptionalReviewersAdded.count(input, nil) == [
             %{contributor_id: "11111111-1111-1111-1111-111111111111", count: 3}
           ]
  end
end
