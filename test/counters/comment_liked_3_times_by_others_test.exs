defmodule Moc.Tests.Counters.CommentLiked3TimesByOthersTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentLiked3TimesByOthers
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentLiked3TimesByOthers.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentLiked3TimesByOthers.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none have 3 or more likes" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1, liked_by: ""},
        %{comment_type: :text, created_by_id: 1, liked_by: "1"},
        %{comment_type: :text, created_by_id: 1, liked_by: "1,2"}
      ]
    }

    assert CommentLiked3TimesByOthers.count(input, nil) == []
  end

  test "returns an empty list when there is one text comment with 3 or more likes but one of them is the author" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1, liked_by: "1,2,3"}
      ]
    }

    assert CommentLiked3TimesByOthers.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment with 3 or more likes" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1, liked_by: "2,3,4"}
      ]
    }

    expected = [%{contributor_id: 1, count: 1}]
    assert CommentLiked3TimesByOthers.count(input, nil) == expected
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments with 3 or more likes" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1, liked_by: "2,3,5"},
        %{comment_type: :text, created_by_id: 1, liked_by: "1,2,3,4"},
        %{comment_type: :text, created_by_id: 2, liked_by: "5,6,7"}
      ]
    }

    assert CommentLiked3TimesByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "ignores comments with less than 3 likes when counting" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1, liked_by: "1,2"},
        %{comment_type: :text, created_by_id: 1, liked_by: "2,3,4"},
        %{comment_type: :text, created_by_id: 2, liked_by: "5,6"}
      ]
    }

    assert CommentLiked3TimesByOthers.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
