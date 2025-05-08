defmodule Moc.Tests.Counters.CommentsRepliedLessThanAMinuteTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentsRepliedLessThanAMinute
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentsRepliedLessThanAMinute.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentsRepliedLessThanAMinute.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but no replies within a minute" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          thread_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z],
          created_by_id: 1
        },
        %{
          comment_type: :text,
          thread_id: 1,
          published_on: ~U[2022-01-01 12:06:00Z],
          created_by_id: 2
        }
      ]
    }

    assert CommentsRepliedLessThanAMinute.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one reply within a minute" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          thread_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z],
          created_by_id: 1
        },
        %{
          comment_type: :text,
          thread_id: 1,
          published_on: ~U[2022-01-01 12:00:59Z],
          created_by_id: 2
        }
      ]
    }

    assert CommentsRepliedLessThanAMinute.count(input, nil) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple replies within a minute" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          thread_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z],
          created_by_id: 1
        },
        %{
          comment_type: :text,
          thread_id: 1,
          published_on: ~U[2022-01-01 12:00:30Z],
          created_by_id: 2
        },
        %{
          comment_type: :text,
          thread_id: 1,
          published_on: ~U[2022-01-01 12:00:45Z],
          created_by_id: 3
        },
        %{
          comment_type: :text,
          thread_id: 2,
          published_on: ~U[2022-01-01 12:00:55Z],
          created_by_id: 4
        },
        %{
          comment_type: :text,
          thread_id: 2,
          published_on: ~U[2022-01-01 12:01:00Z],
          created_by_id: 5
        }
      ]
    }

    assert CommentsRepliedLessThanAMinute.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1},
             %{contributor_id: 5, count: 1}
           ]
  end
end
