defmodule Moc.Tests.Counters.TotalWordsCommentedOnPRTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.TotalWordsCommentedOnPR
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{
      comments: []
    }

    assert TotalWordsCommentedOnPR.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    comments = [
      %{comment_type: :system, content: "voted 10", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalWordsCommentedOnPR.count(input, nil) == []
  end

  test "counts the words in a single text comment" do
    comments = [
      %{comment_type: :text, content: "Hello world", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalWordsCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 2}
           ]
  end

  test "counts the words in multiple text comments" do
    comments = [
      %{comment_type: :text, content: "Hello world: this is a test", created_by_id: 1},
      %{comment_type: :text, content: "Another comment", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalWordsCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 8}
           ]
  end

  test "counts the words in text comments from multiple contributors" do
    comments = [
      %{comment_type: :text, content: "Hello world", created_by_id: 1},
      %{comment_type: :text, content: "Another comment", created_by_id: 2}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalWordsCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 2}
           ]
  end

  test "handles comments with multiple spaces between words" do
    comments = [
      %{comment_type: :text, content: "Hello   world", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert TotalWordsCommentedOnPR.count(input, nil) == [
             %{contributor_id: 1, count: 2}
           ]
  end
end
