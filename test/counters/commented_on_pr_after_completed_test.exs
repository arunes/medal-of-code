defmodule Moc.Tests.Counters.CommentedOnPRAfterCompletedTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedOnPRAfterCompleted
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{closed_on: ~U[2022-01-01 12:00:00Z], comments: []}
    assert CommentedOnPRAfterCompleted.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{
      closed_on: ~U[2022-01-01 12:00:00Z],
      comments: [%{comment_type: :system}]
    }

    assert CommentedOnPRAfterCompleted.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none are after the PR was closed" do
    input = %Type.Input{
      closed_on: ~U[2022-01-01 12:00:00Z],
      comments: [
        %{comment_type: :text, published_on: ~U[2022-01-01 11:59:00Z]}
      ]
    }

    assert CommentedOnPRAfterCompleted.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment after the PR was closed" do
    input = %Type.Input{
      closed_on: ~U[2022-01-01 12:00:00Z],
      comments: [
        %{comment_type: :text, published_on: ~U[2022-01-01 12:01:00Z], created_by_id: 1}
      ]
    }

    assert CommentedOnPRAfterCompleted.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments after the PR was closed" do
    input = %Type.Input{
      closed_on: ~U[2022-01-01 12:00:00Z],
      comments: [
        %{comment_type: :text, published_on: ~U[2022-01-01 12:01:00Z], created_by_id: 1},
        %{comment_type: :text, published_on: ~U[2022-01-01 12:02:00Z], created_by_id: 2},
        %{comment_type: :text, published_on: ~U[2022-01-01 12:03:00Z], created_by_id: 1}
      ]
    }

    assert CommentedOnPRAfterCompleted.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end
end
