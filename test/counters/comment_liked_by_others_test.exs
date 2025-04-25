defmodule Moc.Tests.Counters.CommentLikedByOthersTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentLikedByOthers
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentLikedByOthers.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentLikedByOthers.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none have likes" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: "", created_by_id: 1}
      ]
    }

    assert CommentLikedByOthers.count(input, nil) == []
  end

  test "returns a single contributor with a count of 0 when there is one text comment with no likes from others" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: "1", created_by_id: 1}
      ]
    }

    assert CommentLikedByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 0}
           ]
  end

  test "returns a single contributor with a count of 1 when there is one text comment with one like from another user" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: "2", created_by_id: 1}
      ]
    }

    assert CommentLikedByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a single contributor with a correct count when there is one text comment with multiple likes from other users" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: "2,3,4", created_by_id: 1}
      ]
    }

    assert CommentLikedByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 3}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, liked_by: "2", created_by_id: 1},
        %{comment_type: :text, liked_by: "3,4", created_by_id: 1},
        %{comment_type: :text, liked_by: "5", created_by_id: 2}
      ]
    }

    assert CommentLikedByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 3},
             %{contributor_id: 2, count: 1}
           ]
  end
end
