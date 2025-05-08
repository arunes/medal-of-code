defmodule Moc.Tests.Counters.OwnCommentsRepliedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.OwnCommentsReplied
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert OwnCommentsReplied.count(input, nil) == []
  end

  test "returns an empty list when there are no self-replied comments" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:00Z",
          thread_id: 1,
          created_by_id: 1
        },
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:01Z",
          thread_id: 1,
          created_by_id: 2
        }
      ]
    }

    assert OwnCommentsReplied.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when a comment is self-replied" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:00Z",
          thread_id: 1,
          created_by_id: 1
        },
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:01Z",
          thread_id: 1,
          created_by_id: 1
        }
      ]
    }

    assert OwnCommentsReplied.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with a count of 1 when multiple comments are self-replied" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:00Z",
          thread_id: 1,
          created_by_id: 1
        },
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:01Z",
          thread_id: 1,
          created_by_id: 1
        },
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:02Z",
          thread_id: 2,
          created_by_id: 2
        },
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:03Z",
          thread_id: 2,
          created_by_id: 2
        }
      ]
    }

    assert OwnCommentsReplied.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "ignores non-text comments" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :system,
          inserted_at: "2022-01-01T00:00:00Z",
          thread_id: 1,
          created_by_id: 1
        },
        %{
          comment_type: :system,
          inserted_at: "2022-01-01T00:00:01Z",
          thread_id: 1,
          created_by_id: 1
        }
      ]
    }

    assert OwnCommentsReplied.count(input, nil) == []
  end

  test "ignores comments from different threads" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:00Z",
          thread_id: 1,
          created_by_id: 1
        },
        %{
          comment_type: :text,
          inserted_at: "2022-01-01T00:00:01Z",
          thread_id: 2,
          created_by_id: 1
        }
      ]
    }

    assert OwnCommentsReplied.count(input, nil) == []
  end
end
