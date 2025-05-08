defmodule Moc.Tests.Counters.PrsCompletedIn10MinutesTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsCompletedIn10Minutes
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is not completed" do
    input = %Type.Input{
      status: :open,
      created_by_id: 1,
      created_on: ~U[2022-01-01 00:00:00.000000Z],
      closed_on: ~U[2022-01-01 00:15:00.000000Z]
    }

    assert PrsCompletedIn10Minutes.count(input, nil) == []
  end

  test "returns an empty list when the PR is completed after 10 minutes" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      created_on: ~U[2022-01-01 00:00:00.000000Z],
      closed_on: ~U[2022-01-01 00:15:00.000000Z]
    }

    assert PrsCompletedIn10Minutes.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is completed within 10 minutes" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      created_on: ~U[2022-01-01 00:00:00.000000Z],
      closed_on: ~U[2022-01-01 00:05:00.000000Z]
    }

    assert PrsCompletedIn10Minutes.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
