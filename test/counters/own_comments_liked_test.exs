defmodule Moc.Tests.Counters.OwnCommentsLikedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.OwnCommentsLiked
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert OwnCommentsLiked.count(input, nil) == []
  end

  test "returns an empty list when there are no self-liked comments" do
    input = %Type.Input{
      comments: [
        %{liked_by: "2,3", created_by_id: 1}
      ]
    }

    assert OwnCommentsLiked.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when a comment is self-liked" do
    input = %Type.Input{
      comments: [
        %{liked_by: "1,2,3", created_by_id: 1}
      ]
    }

    assert OwnCommentsLiked.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when multiple comments are self-liked" do
    input = %Type.Input{
      comments: [
        %{liked_by: "1,2,3", created_by_id: 1},
        %{liked_by: "2,3,2", created_by_id: 2}
      ]
    }

    assert OwnCommentsLiked.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "handles empty liked_by string" do
    input = %Type.Input{
      comments: [
        %{liked_by: "", created_by_id: 1}
      ]
    }

    assert OwnCommentsLiked.count(input, nil) == []
  end

  test "handles multiple self-likes" do
    input = %Type.Input{
      comments: [
        %{liked_by: "1,1,2,3", created_by_id: 1}
      ]
    }

    assert OwnCommentsLiked.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
