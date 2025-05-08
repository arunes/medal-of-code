defmodule Moc.Tests.Counters.CommentNotRepliedAfterMentionedTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentNotRepliedAfterMentioned
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentNotRepliedAfterMentioned.count(input, fn -> nil end) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentNotRepliedAfterMentioned.count(input, fn -> nil end) == []
  end

  test "returns an empty list when there are text comments but no mentions" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello world"}
      ]
    }

    assert CommentNotRepliedAfterMentioned.count(input, fn -> nil end) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment with a mention and no reply" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "Hello @<12345678-1234-1234-1234-123456789012>",
          created_by_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z],
          thread_id: 1
        }
      ]
    }

    get_data = fn
      :contributor_by_id, "12345678-1234-1234-1234-123456789012" -> 2
    end

    assert CommentNotRepliedAfterMentioned.count(input, get_data) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns an empty list when there is one text comment with a mention and a reply" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "Hello @<12345678-1234-1234-1234-123456789012>",
          created_by_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z],
          thread_id: 1
        },
        %{
          comment_type: :text,
          content: "Reply",
          created_by_id: 2,
          published_on: ~U[2022-01-01 12:01:00Z],
          thread_id: 1
        }
      ]
    }

    get_data = fn
      :contributor_by_id, "12345678-1234-1234-1234-123456789012" -> 2
    end

    assert CommentNotRepliedAfterMentioned.count(input, get_data) == []
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments with mentions" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "Hello @<12345678-1234-1234-1234-123456789012>",
          created_by_id: 1,
          published_on: ~U[2022-01-01 12:00:00Z],
          thread_id: 1
        },
        %{
          comment_type: :text,
          content: "Hello @<23456789-2345-2345-2345-234567890123>",
          created_by_id: 1,
          published_on: ~U[2022-01-01 12:01:00Z],
          thread_id: 2
        }
      ]
    }

    get_data = fn
      :contributor_by_id, "12345678-1234-1234-1234-123456789012" -> 2
      :contributor_by_id, "23456789-2345-2345-2345-234567890123" -> 3
    end

    assert CommentNotRepliedAfterMentioned.count(input, get_data) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1}
           ]
  end
end
