defmodule Moc.Tests.Counters.MergeConflictsResolvedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.MergeConflictsResolved
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert MergeConflictsResolved.count(input, nil) == []
  end

  test "returns an empty list when there are no conflict resolution comments" do
    input = %Type.Input{
      comments: [
        %{
          content: "Hello world",
          created_by_id: "11111111-1111-1111-1111-111111111111",
          comment_type: :text
        }
      ]
    }

    assert MergeConflictsResolved.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there is a conflict resolution comment" do
    input = %Type.Input{
      comments: [
        %{
          content: "Submitted conflict resolution for the file(s).",
          created_by_id: "11111111-1111-1111-1111-111111111111",
          comment_type: :text
        }
      ]
    }

    assert MergeConflictsResolved.count(input, nil) == [
             %{contributor_id: "11111111-1111-1111-1111-111111111111", count: 1}
           ]
  end

  test "ignores non-text comments" do
    input = %Type.Input{
      comments: [
        %{
          content: "Submitted conflict resolution for the file(s).",
          created_by_id: "11111111-1111-1111-1111-111111111111",
          comment_type: :image
        }
      ]
    }

    assert MergeConflictsResolved.count(input, nil) == []
  end

  test "returns multiple contributors with a count of 1 when there are multiple conflict resolution comments" do
    input = %Type.Input{
      comments: [
        %{
          content: "Submitted conflict resolution for the file(s).",
          created_by_id: "11111111-1111-1111-1111-111111111111",
          comment_type: :text
        },
        %{
          content: "Submitted conflict resolution for the file(s).",
          created_by_id: "22222222-2222-2222-2222-222222222222",
          comment_type: :text
        }
      ]
    }

    assert MergeConflictsResolved.count(input, nil) == [
             %{contributor_id: "11111111-1111-1111-1111-111111111111", count: 1},
             %{contributor_id: "22222222-2222-2222-2222-222222222222", count: 1}
           ]
  end
end
