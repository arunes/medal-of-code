defmodule Moc.Tests.Counters.SamePRVotedAtLeast5TimesTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.SamePRVotedAtLeast5Times
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{
      comments: []
    }

    assert SamePRVotedAtLeast5Times.count(input, nil) == []
  end

  test "returns an empty list when there are no system comments with votes" do
    comments = [
      %{comment_type: :text, content: "Hello", created_by_id: 1},
      %{comment_type: :system, content: "Something else", created_by_id: 2}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert SamePRVotedAtLeast5Times.count(input, nil) == []
  end

  test "returns an empty list when a user hasn't voted at least 5 times" do
    comments = [
      %{comment_type: :system, content: "voted 10", created_by_id: 1},
      %{comment_type: :system, content: "voted 5", created_by_id: 1},
      %{comment_type: :system, content: "voted -5", created_by_id: 1},
      %{comment_type: :system, content: "voted 10", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert SamePRVotedAtLeast5Times.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when a user has voted at least 5 times" do
    comments = [
      %{comment_type: :system, content: "voted 10", created_by_id: 1},
      %{comment_type: :system, content: "voted 5", created_by_id: 1},
      %{comment_type: :system, content: "voted -5", created_by_id: 1},
      %{comment_type: :system, content: "voted 10", created_by_id: 1},
      %{comment_type: :system, content: "voted 5", created_by_id: 1}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert SamePRVotedAtLeast5Times.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when multiple users have voted at least 5 times" do
    comments = [
      %{comment_type: :system, content: "voted 10", created_by_id: 1},
      %{comment_type: :system, content: "voted 5", created_by_id: 1},
      %{comment_type: :system, content: "voted -5", created_by_id: 1},
      %{comment_type: :system, content: "voted 10", created_by_id: 1},
      %{comment_type: :system, content: "voted 5", created_by_id: 1},
      %{comment_type: :system, content: "voted 10", created_by_id: 2},
      %{comment_type: :system, content: "voted 5", created_by_id: 2},
      %{comment_type: :system, content: "voted -5", created_by_id: 2},
      %{comment_type: :system, content: "voted 10", created_by_id: 2},
      %{comment_type: :system, content: "voted 5", created_by_id: 2}
    ]

    input = %Type.Input{
      comments: comments
    }

    assert SamePRVotedAtLeast5Times.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end
end
