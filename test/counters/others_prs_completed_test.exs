defmodule Moc.Tests.Counters.OthersPRsCompletedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.OthersPRsCompleted
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no completion comments" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      comments: []
    }

    assert OthersPRsCompleted.count(input, nil) == []
  end

  test "returns an empty list when the completion comment is not from another user" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      comments: [
        %{
          content: "updated the pull request status to Completed",
          comment_type: :system,
          created_by_id: "11111111-1111-1111-1111-111111111111"
        }
      ]
    }

    assert OthersPRsCompleted.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when another user completes the PR" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      comments: [
        %{
          content: "updated the pull request status to Completed",
          comment_type: :system,
          created_by_id: "22222222-2222-2222-2222-222222222222"
        }
      ]
    }

    assert OthersPRsCompleted.count(input, nil) == [
             %{contributor_id: "22222222-2222-2222-2222-222222222222", count: 1}
           ]
  end

  test "ignores non-system comments" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      comments: [
        %{
          content: "updated the pull request status to Completed",
          comment_type: :text,
          created_by_id: "22222222-2222-2222-2222-222222222222"
        }
      ]
    }

    assert OthersPRsCompleted.count(input, nil) == []
  end

  test "ignores system comments that don't complete the PR" do
    input = %Type.Input{
      created_by_id: "11111111-1111-1111-1111-111111111111",
      comments: [
        %{
          content: "Hello world",
          comment_type: :system,
          created_by_id: "22222222-2222-2222-2222-222222222222"
        }
      ]
    }

    assert OthersPRsCompleted.count(input, nil) == []
  end
end
