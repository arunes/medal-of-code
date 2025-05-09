defmodule Moc.Tests.Counters.ReceivedAtLeast100CommentsOnAPRTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.ReceivedAtLeast100CommentsOnAPR
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are less than 100 comments" do
    comments = Enum.map(1..99, fn i -> %{comment_type: :text, id: i} end)

    input = %Type.Input{
      created_by_id: 1,
      comments: comments
    }

    assert ReceivedAtLeast100CommentsOnAPR.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there are exactly 100 comments" do
    comments = Enum.map(1..100, fn i -> %{comment_type: :text, id: i} end)

    input = %Type.Input{
      created_by_id: 1,
      comments: comments
    }

    assert ReceivedAtLeast100CommentsOnAPR.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when there are more than 100 comments" do
    comments = Enum.map(1..101, fn i -> %{comment_type: :text, id: i} end)

    input = %Type.Input{
      created_by_id: 1,
      comments: comments
    }

    assert ReceivedAtLeast100CommentsOnAPR.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "only counts text comments" do
    comments =
      Enum.map(1..99, fn i -> %{comment_type: :text, id: i} end) ++ [%{comment_type: :system}]

    input = %Type.Input{
      created_by_id: 1,
      comments: comments
    }

    assert ReceivedAtLeast100CommentsOnAPR.count(input, nil) == []
  end

  test "returns an empty list when there are no comments" do
    input = %Type.Input{
      created_by_id: 1,
      comments: []
    }

    assert ReceivedAtLeast100CommentsOnAPR.count(input, nil) == []
  end
end
