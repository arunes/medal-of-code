defmodule Moc.Tests.Counters.CommentsRepliedTest do
  use ExUnit.Case

  alias Moc.Counters.CommentsReplied
  alias Moc.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentsReplied.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: "system"}]}
    assert CommentsReplied.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but no replies" do
    input = %Type.Input{
      comments: [
        %{comment_type: "text", thread_id: 1, created_by_id: 1},
        %{comment_type: "text", thread_id: 2, created_by_id: 2}
      ]
    }

    assert CommentsReplied.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one reply" do
    input = %Type.Input{
      comments: [
        %{comment_type: "text", thread_id: 1, created_by_id: 1},
        %{comment_type: "text", thread_id: 1, created_by_id: 2}
      ]
    }

    assert CommentsReplied.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple replies" do
    input = %Type.Input{
      comments: [
        %{comment_type: "text", thread_id: 1, created_by_id: 1},
        %{comment_type: "text", thread_id: 1, created_by_id: 2},
        %{comment_type: "text", thread_id: 1, created_by_id: 3},
        %{comment_type: "text", thread_id: 2, created_by_id: 4},
        %{comment_type: "text", thread_id: 2, created_by_id: 5}
      ]
    }

    assert CommentsReplied.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1},
             %{contributor_id: 5, count: 1}
           ]
  end

  test "ignores self-replies" do
    input = %Type.Input{
      comments: [
        %{comment_type: "text", thread_id: 1, created_by_id: 1},
        %{comment_type: "text", thread_id: 1, created_by_id: 1}
      ]
    }

    assert CommentsReplied.count(input, nil) == []
  end
end
