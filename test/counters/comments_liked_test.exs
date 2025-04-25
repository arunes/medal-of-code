defmodule Moc.Tests.Counters.CommentsLikedTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentsLiked
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentsLiked.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentsLiked.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none have likes" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: ""}
      ]
    }

    assert CommentsLiked.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one like" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: "1"}
      ]
    }

    assert CommentsLiked.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple likes" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: "1,2"},
        %{comment_type: :text, liked_by: "2,3"},
        %{comment_type: :text, liked_by: "1"}
      ]
    }

    assert CommentsLiked.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 2},
             %{contributor_id: 3, count: 1}
           ]
  end
end
