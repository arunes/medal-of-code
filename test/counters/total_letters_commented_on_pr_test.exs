defmodule Moc.Tests.Counters.TotalLettersCommentedOnPRTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.TotalLettersCommentedOnPR
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{
      comments: []
    }

    assert TotalLettersCommentedOnPR.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    comments = [
      %{comment_type: :system, content: "voted 10", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalLettersCommentedOnPR.count(input, nil) == []
  end

  test "counts the letters in a single text comment" do
    comments = [
      %{comment_type: :text, content: "Hello", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalLettersCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 5}
           ]
  end

  test "counts the letters in multiple text comments" do
    comments = [
      %{comment_type: :text, content: "Hello", created_by_id: 1},
      %{comment_type: :text, content: "World", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalLettersCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 10}
           ]
  end

  test "counts the letters in text comments from multiple contributors" do
    comments = [
      %{comment_type: :text, content: "Hello", created_by_id: 1},
      %{comment_type: :text, content: "World", created_by_id: 2}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalLettersCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 5},
             %{contributor_id: 2, count: 5}
           ]
  end

  test "counts spaces and punctuation as letters" do
    comments = [
      %{comment_type: :text, content: "Hello, World!", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalLettersCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 13}
           ]
  end
end
