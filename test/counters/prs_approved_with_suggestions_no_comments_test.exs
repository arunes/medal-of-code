defmodule Moc.Tests.Counters.PrsApprovedWithSuggestionsNoCommentsTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsApprovedWithSuggestionsNoComments
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no reviews" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [],
      comments: []
    }

    assert PrsApprovedWithSuggestionsNoComments.count(input, nil) == []
  end

  test "returns an empty list when there are no approvals with suggestions" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 0, reviewer_id: 2},
        %{vote: 10, reviewer_id: 3},
        %{vote: -5, reviewer_id: 4},
        %{vote: -10, reviewer_id: 5}
      ],
      comments: []
    }

    assert PrsApprovedWithSuggestionsNoComments.count(input, nil) == []
  end

  test "returns an empty list when the approval with suggestions is from the PR author" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 5, reviewer_id: 1}
      ],
      comments: []
    }

    assert PrsApprovedWithSuggestionsNoComments.count(input, nil) == []
  end

  test "returns an empty list when the approval with suggestions has a comment" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 5, reviewer_id: 2}
      ],
      comments: [
        %{comment_type: :text, created_by_id: 2}
      ]
    }

    assert PrsApprovedWithSuggestionsNoComments.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is approved with suggestions and no comments" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 5, reviewer_id: 2}
      ],
      comments: [
        %{comment_type: :text, created_by_id: 3}
      ]
    }

    assert PrsApprovedWithSuggestionsNoComments.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when the PR is approved with suggestions and no comments by multiple reviewers" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [
        %{vote: 5, reviewer_id: 2},
        %{vote: 5, reviewer_id: 3}
      ],
      comments: [
        %{comment_type: :text, created_by_id: 4}
      ]
    }

    assert PrsApprovedWithSuggestionsNoComments.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1}
           ]
  end
end
