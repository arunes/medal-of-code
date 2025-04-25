defmodule Moc.Tests.Counters.CommentedAllUppercaseTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedAllUppercase
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedAllUppercase.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedAllUppercase.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none are all uppercase" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World", created_by_id: 1},
        %{comment_type: :text, content: "hello world", created_by_id: 1}
      ]
    }

    assert CommentedAllUppercase.count(input, nil) == []
  end

  test "returns an empty list when there are text comments with all numbers and symbols" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "@!()", created_by_id: 1},
        %{comment_type: :text, content: "12345", created_by_id: 1}
      ]
    }

    assert CommentedAllUppercase.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one all uppercase text comment" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "HELLO WORLD", created_by_id: 1}
      ]
    }

    assert CommentedAllUppercase.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a single contributor with a count of 1 when there is one all uppercase text comment with symbols and numbers" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "HELLO 2 WORLD!", created_by_id: 1}
      ]
    }

    assert CommentedAllUppercase.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple all uppercase text comments" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "HELLO WORLD", created_by_id: 1},
        %{comment_type: :text, content: "HELLO WORLD", created_by_id: 1},
        %{comment_type: :text, content: "HELLO AGAIN", created_by_id: 2}
      ]
    }

    assert CommentedAllUppercase.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end
end
