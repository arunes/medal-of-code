defmodule Moc.Tests.Counters.FilesFixedInMergeConflictTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.FilesFixedInMergeConflict
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert FilesFixedInMergeConflict.count(input, nil) == []
  end

  test "returns an empty list when there are no merge conflict comments" do
    input = %Type.Input{
      comments: [
        %{type: :text, content: "Hello World"},
        %{type: :system, content: "This is a system comment"}
      ]
    }

    assert FilesFixedInMergeConflict.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one merge conflict comment with one file" do
    input = %Type.Input{
      comments: [
        %{
          type: :text,
          content: "Submitted conflict resolution for the file(s).\nfile1.txt",
          created_by_id: 1
        }
      ]
    }

    assert FilesFixedInMergeConflict.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a single contributor with a count of 2 when there is one merge conflict comment with two files" do
    input = %Type.Input{
      comments: [
        %{
          type: :text,
          content: "Submitted conflict resolution for the file(s).\nfile1.txt\nfile2.txt",
          created_by_id: 1
        }
      ]
    }

    assert FilesFixedInMergeConflict.count(input, nil) == [
             %{contributor_id: 1, count: 2}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple merge conflict comments" do
    input = %Type.Input{
      comments: [
        %{
          type: :text,
          content: "Submitted conflict resolution for the file(s).\nfile1.txt",
          created_by_id: 1
        },
        %{
          type: :text,
          content: "Submitted conflict resolution for the file(s).\nfile2.txt\nfile3.txt",
          created_by_id: 2
        }
      ]
    }

    assert FilesFixedInMergeConflict.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 2}
           ]
  end
end
