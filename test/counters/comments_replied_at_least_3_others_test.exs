defmodule Moc.Tests.Counters.CommentsRepliedAtLeast3OthersTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentsRepliedAtLeast3Others
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentsRepliedAtLeast3Others.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentsRepliedAtLeast3Others.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but no threads with at least 3 replies" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 2,
          published_on: ~U[2022-01-01 12:01:00Z]
        }
      ]
    }

    assert CommentsRepliedAtLeast3Others.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one thread with at least 3 replies" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 2,
          published_on: ~U[2022-01-01 12:01:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 3,
          published_on: ~U[2022-01-01 12:02:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 4,
          published_on: ~U[2022-01-01 12:03:00Z]
        }
      ]
    }

    assert CommentsRepliedAtLeast3Others.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple threads with at least 3 replies" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 2,
          published_on: ~U[2022-01-01 12:01:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 3,
          published_on: ~U[2022-01-01 12:02:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 1,
          created_by_id: 4,
          published_on: ~U[2022-01-01 12:03:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 2,
          created_by_id: 5,
          published_on: ~U[2022-01-01 12:04:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 2,
          created_by_id: 6,
          published_on: ~U[2022-01-01 12:05:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 2,
          created_by_id: 7,
          published_on: ~U[2022-01-01 12:06:00Z]
        },
        %{
          comment_type: :text,
          thread_id: 2,
          created_by_id: 8,
          published_on: ~U[2022-01-01 12:07:00Z]
        }
      ]
    }

    assert CommentsRepliedAtLeast3Others.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 5, count: 1}
           ]
  end
end
