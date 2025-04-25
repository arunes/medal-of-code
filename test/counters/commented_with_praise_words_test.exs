defmodule Moc.Tests.Counters.CommentedWithPraiseWordsTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedWithPraiseWords
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedWithPraiseWords.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedWithPraiseWords.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none contain praise words" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World"},
        %{comment_type: :text, content: "This is a test"}
      ]
    }

    assert CommentedWithPraiseWords.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment with a praise word" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "This is awesome!", created_by_id: 1}
      ]
    }

    assert CommentedWithPraiseWords.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments with praise words" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "This is awesome!", created_by_id: 1},
        %{comment_type: :text, content: "This is great!", created_by_id: 2},
        %{comment_type: :text, content: "This is cool!", created_by_id: 1}
      ]
    }

    assert CommentedWithPraiseWords.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "matches praise words regardless of case" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "This is AWESOME!", created_by_id: 1}
      ]
    }

    assert CommentedWithPraiseWords.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
