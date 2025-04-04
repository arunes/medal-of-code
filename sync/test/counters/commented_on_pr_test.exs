defmodule Moc.Tests.Counters.CommentedOnPRTest do
  use ExUnit.Case
  alias Moc.Sync.Impl.Counters.CommentedOnPR


  @pull_request %Moc.Db.Schema.PullRequest{comments: [
    %Moc.Db.Schema.PullRequestComment{ comment_type: "text", created_by_id: 1 },
    %Moc.Db.Schema.PullRequestComment{ comment_type: "text", created_by_id: 1 },
    %Moc.Db.Schema.PullRequestComment{ comment_type: "text", created_by_id: 2 },
    %Moc.Db.Schema.PullRequestComment{ comment_type: "text", created_by_id: 2 },
    %Moc.Db.Schema.PullRequestComment{ comment_type: "text", created_by_id: 2 },
    %Moc.Db.Schema.PullRequestComment{ comment_type: "text", created_by_id: 2 },
  ]}

  @pull_request_empty %Moc.Db.Schema.PullRequest{comments: []}


  test "checks if empty comment list returns empty results" do
    assert length(CommentedOnPR.count(@pull_request_empty)) == 0
  end

  test "checks if counts correctly when list is full" do
    result = CommentedOnPR.count(@pull_request) |> IO.inspect()

    assert Enum.member?(result, %{contributor_id: 1, count: 1})
    assert Enum.member?(result, %{contributor_id: 2, count: 1})
    refute Enum.member?(result, %{contributor_id: 3, count: 1})

    assert Enum.count(result, fn r -> r.contributor_id == 1 end) == 2
    assert Enum.count(result, fn r -> r.contributor_id == 2 end) == 4
    assert Enum.count(result, fn r -> r.contributor_id == 3 end) == 0
  end
end
