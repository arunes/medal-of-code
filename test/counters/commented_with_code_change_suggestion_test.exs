defmodule Moc.Tests.Counters.CommentedWithCodeChangeSuggestionTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedWithCodeChangeSuggestion
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedWithCodeChangeSuggestion.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedWithCodeChangeSuggestion.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none contain a code change suggestion" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World"},
        %{comment_type: :text, content: "This is a suggestion"}
      ]
    }

    assert CommentedWithCodeChangeSuggestion.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment with a code change suggestion" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "```suggestion\nThis is a code change suggestion```",
          created_by_id: 1
        }
      ]
    }

    assert CommentedWithCodeChangeSuggestion.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments with code change suggestions" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "```suggestion\nThis is a code change suggestion```",
          created_by_id: 1
        },
        %{
          comment_type: :text,
          content: "```suggestion\nThis is another code change suggestion```",
          created_by_id: 2
        },
        %{
          comment_type: :text,
          content: "```suggestion\nThis is yet another code change suggestion```",
          created_by_id: 1
        }
      ]
    }

    assert CommentedWithCodeChangeSuggestion.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end
end
