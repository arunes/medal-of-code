defmodule Moc.Tests.Counters.CommentedOwnPRBeforeOthersTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedOwnPRBeforeOthers
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{created_by_id: 1, comments: []}
    assert CommentedOwnPRBeforeOthers.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [%{comment_type: :system}]
    }

    assert CommentedOwnPRBeforeOthers.count(input, nil) == []
  end

  test "returns an empty list when the PR creator did not comment first" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [
        %{comment_type: :text, created_by_id: 2, published_on: ~N[2022-01-01 12:00:00]},
        %{comment_type: :text, created_by_id: 1, published_on: ~N[2022-01-01 12:01:00]}
      ]
    }

    assert CommentedOwnPRBeforeOthers.count(input, nil) == []
  end

  test "returns the PR creator with a count of 1 when they commented first" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [
        %{comment_type: :text, created_by_id: 1, published_on: ~N[2022-01-01 12:00:00]},
        %{comment_type: :text, created_by_id: 2, published_on: ~N[2022-01-01 12:01:00]}
      ]
    }

    assert CommentedOwnPRBeforeOthers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns the PR creator with a count of 1 when they are the only commenter" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [
        %{comment_type: :text, created_by_id: 1, published_on: ~N[2022-01-01 12:00:00]}
      ]
    }

    assert CommentedOwnPRBeforeOthers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
