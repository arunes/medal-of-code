defmodule Moc.Tests.Counters.CommentsRepliedLessThan5MinutesTest do
  use ExUnit.Case

  alias Moc.Sync.Counters.CommentsRepliedLessThan5Minutes
  alias Moc.Sync.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentsRepliedLessThan5Minutes.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: "system"}]}
    assert CommentsRepliedLessThan5Minutes.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but no replies within 5 minutes" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: "text",
          thread_id: 1,
          published_on: ~N[2022-01-01 12:00:00],
          created_by_id: 1
        },
        %{
          comment_type: "text",
          thread_id: 1,
          published_on: ~N[2022-01-01 12:06:00],
          created_by_id: 2
        }
      ]
    }

    assert CommentsRepliedLessThan5Minutes.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one reply within 5 minutes" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: "text",
          thread_id: 1,
          published_on: ~N[2022-01-01 12:00:00],
          created_by_id: 1
        },
        %{
          comment_type: "text",
          thread_id: 1,
          published_on: ~N[2022-01-01 12:04:00],
          created_by_id: 2
        }
      ]
    }

    assert CommentsRepliedLessThan5Minutes.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple replies within 5 minutes" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: "text",
          thread_id: 1,
          published_on: ~N[2022-01-01 12:00:00],
          created_by_id: 1
        },
        %{
          comment_type: "text",
          thread_id: 1,
          published_on: ~N[2022-01-01 12:02:00],
          created_by_id: 2
        },
        %{
          comment_type: "text",
          thread_id: 1,
          published_on: ~N[2022-01-01 12:03:00],
          created_by_id: 3
        },
        %{
          comment_type: "text",
          thread_id: 2,
          published_on: ~N[2022-01-01 12:05:00],
          created_by_id: 4
        },
        %{
          comment_type: "text",
          thread_id: 2,
          published_on: ~N[2022-01-01 12:06:00],
          created_by_id: 5
        }
      ]
    }

    assert CommentsRepliedLessThan5Minutes.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1},
             %{contributor_id: 5, count: 1}
           ]
  end
end
