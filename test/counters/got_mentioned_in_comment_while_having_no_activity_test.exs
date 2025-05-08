defmodule Moc.Tests.Counters.GotMentionedInCommentWhileHavingNoActivityTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.GotMentionedInCommentWhileHavingNoActivity
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{created_by_id: 1, comments: []}
    assert GotMentionedInCommentWhileHavingNoActivity.count(input, nil) == []
  end

  test "returns an empty list when there are no mentions" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [
        %{comment_type: :text, content: "Hello world"}
      ]
    }

    assert GotMentionedInCommentWhileHavingNoActivity.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when mentioned in a comment" do
    input = %Type.Input{
      created_by_id: 1,
      reviews: [],
      comments: [
        %{
          comment_type: :text,
          created_by_id: "",
          content: "@<12345678-1234-1234-1234-123456789012>"
        }
      ]
    }

    get_data = fn
      :contributor_by_id, "12345678-1234-1234-1234-123456789012" -> 2
    end

    assert GotMentionedInCommentWhileHavingNoActivity.count(input, get_data) == [
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns an empty list when mentioned contributor has prior activity" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [
        %{comment_type: :text, content: "@<[{12345678-1234-1234-1234-123456789012}]>"}
      ],
      reviews: [
        %{reviewer_id: "12345678-1234-1234-1234-123456789012"}
      ]
    }

    get_data = fn
      :contributor_by_id, "12345678-1234-1234-1234-123456789012" -> 2
    end

    assert GotMentionedInCommentWhileHavingNoActivity.count(input, get_data) == []
  end

  test "returns an empty list when mentioned contributor has prior comments" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [
        %{comment_type: :text, content: "@<[{12345678-1234-1234-1234-123456789012}]>"},
        %{
          comment_type: :text,
          content: "Hello",
          created_by_id: "12345678-1234-1234-1234-123456789012",
          published_on: ~U[2022-01-01 00:00:00Z]
        }
      ]
    }

    get_data = fn
      :contributor_by_id, "12345678-1234-1234-1234-123456789012" -> 2
    end

    assert GotMentionedInCommentWhileHavingNoActivity.count(input, get_data) == []
  end

  test "returns a contributor with a count of 1 when mentioned multiple times" do
    input = %Type.Input{
      created_by_id: 1,
      comments: [
        %{
          comment_type: :text,
          created_by_id: "",
          content: "@<12345678-1234-1234-1234-123456789012>"
        },
        %{
          comment_type: :text,
          created_by_id: "",
          content: "@<12345678-1234-1234-1234-123456789012>"
        }
      ],
      reviews: []
    }

    get_data = fn
      :contributor_by_id, "12345678-1234-1234-1234-123456789012" -> 2
    end

    assert GotMentionedInCommentWhileHavingNoActivity.count(input, get_data) == [
             %{contributor_id: 2, count: 1}
           ]
  end
end
