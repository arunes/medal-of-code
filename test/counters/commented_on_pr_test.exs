defmodule Moc.Tests.Counters.CommentedOnPRTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedOnPR
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedOnPR.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedOnPR.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment" do
    input = %Type.Input{comments: [%{comment_type: :text, created_by_id: 1}]}
    assert CommentedOnPR.count(input, nil) == [%{contributor_id: 1, count: 1}]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 2}
      ]
    }

    assert CommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "ignores non-text comments when counting" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :system, created_by_id: 1},
        %{comment_type: :text, created_by_id: 2}
      ]
    }

    assert CommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end
end
