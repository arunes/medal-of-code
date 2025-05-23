defmodule Moc.Tests.Counters.PrsCompletedTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsCompleted
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is not completed" do
    input = %Type.Input{
      status: :abandoned,
      created_by_id: 1
    }

    assert PrsCompleted.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is completed" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1
    }

    assert PrsCompleted.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
