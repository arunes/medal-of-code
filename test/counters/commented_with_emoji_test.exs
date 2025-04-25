defmodule Moc.Tests.Counters.CommentedWithEmojiTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedWithEmoji
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedWithEmoji.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedWithEmoji.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none contain an emoji" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World"},
        %{comment_type: :text, content: "This is a test"}
      ]
    }

    assert CommentedWithEmoji.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment with an emoji" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World 👋", created_by_id: 1}
      ]
    }

    assert CommentedWithEmoji.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments with emojis" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World 👋", created_by_id: 1},
        %{comment_type: :text, content: "This is a test 🤔", created_by_id: 2},
        %{comment_type: :text, content: "Another test 👍", created_by_id: 1}
      ]
    }

    assert CommentedWithEmoji.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end
end
