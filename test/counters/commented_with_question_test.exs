defmodule Moc.Tests.Counters.CommentedWithQuestionTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedWithQuestion
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedWithQuestion.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedWithQuestion.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none end with a question mark" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World"},
        %{comment_type: :text, content: "This is a test"}
      ]
    }

    assert CommentedWithQuestion.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment that ends with a question mark" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "What's going on?", created_by_id: 1}
      ]
    }

    assert CommentedWithQuestion.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments that end with a question mark" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "What's going on?", created_by_id: 1},
        %{comment_type: :text, content: "How does this work?", created_by_id: 2},
        %{comment_type: :text, content: "Is this correct?", created_by_id: 1}
      ]
    }

    assert CommentedWithQuestion.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end
end
