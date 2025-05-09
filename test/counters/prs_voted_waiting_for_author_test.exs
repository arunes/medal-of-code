defmodule Moc.Tests.Counters.PrsVotedWaitingForAuthorTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsVotedWaitingForAuthor
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{
      comments: []
    }

    assert PrsVotedWaitingForAuthor.count(input, nil) == []
  end

  test "returns an empty list when there are no system comments with vote -5" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello", created_by_id: 1},
        %{comment_type: :system, content: "voted 10", created_by_id: 2}
      ]
    }

    assert PrsVotedWaitingForAuthor.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there is a system comment with vote -5" do
    input = %Type.Input{
      comments: [
        %{comment_type: :system, content: "User voted -5", created_by_id: 1}
      ]
    }

    assert PrsVotedWaitingForAuthor.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when there are multiple system comments with vote -5" do
    input = %Type.Input{
      comments: [
        %{comment_type: :system, content: "User1 voted -5", created_by_id: 1},
        %{comment_type: :system, content: "User2 voted -5", created_by_id: 2}
      ]
    }

    assert PrsVotedWaitingForAuthor.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "only counts system comments with exact vote -5 string" do
    input = %Type.Input{
      comments: [
        %{comment_type: :system, content: "User voted -5 something", created_by_id: 1},
        %{comment_type: :system, content: "User voted -5", created_by_id: 2}
      ]
    }

    assert PrsVotedWaitingForAuthor.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end
end
