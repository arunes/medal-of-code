defmodule Moc.Tests.Counters.PrsVotedAsOptionalReviewerTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsVotedAsOptionalReviewer
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: []
    }

    assert PrsVotedAsOptionalReviewer.count(input, nil) == []
  end

  test "returns an empty list when there are no optional reviewers who voted" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{is_required: true, vote: 10, reviewer_id: 2},
        %{is_required: true, vote: 5, reviewer_id: 3}
      ]
    }

    assert PrsVotedAsOptionalReviewer.count(input, nil) == []
  end

  test "returns an empty list when the optional reviewer didn't vote" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{is_required: false, vote: 0, reviewer_id: 2}
      ]
    }

    assert PrsVotedAsOptionalReviewer.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the optional reviewer voted" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{is_required: false, vote: 10, reviewer_id: 2}
      ]
    }

    assert PrsVotedAsOptionalReviewer.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when multiple optional reviewers voted" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{is_required: false, vote: 10, reviewer_id: 2},
        %{is_required: false, vote: 5, reviewer_id: 3}
      ]
    }

    assert PrsVotedAsOptionalReviewer.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1}
           ]
  end

  test "doesn't count the PR creator" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{is_required: false, vote: 10, reviewer_id: 1}
      ]
    }

    assert PrsVotedAsOptionalReviewer.count(input, nil) == []
  end
end
