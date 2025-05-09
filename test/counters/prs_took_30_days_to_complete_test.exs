defmodule Moc.Tests.Counters.PrsTook30DaysToCompleteTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsTook30DaysToComplete
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is completed less than 30 days" do
    created_on = ~U[2022-01-01 00:00:00Z]
    closed_on = ~U[2022-01-30 00:00:00Z]

    input = %Type.Input{
      created_by_id: 1,
      created_on: created_on,
      closed_on: closed_on
    }

    assert PrsTook30DaysToComplete.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR takes more than 30 days to complete" do
    created_on = ~U[2022-01-01 00:00:00Z]
    closed_on = ~U[2022-02-01 00:00:01Z]

    input = %Type.Input{
      created_by_id: 1,
      created_on: created_on,
      closed_on: closed_on
    }

    assert PrsTook30DaysToComplete.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns an empty list when the PR is completed on the 29th day" do
    created_on = ~U[2022-01-01 00:00:00Z]
    closed_on = DateTime.add(created_on, 29 * 24 * 60 * 60, :second)

    input = %Type.Input{
      created_by_id: 1,
      created_on: created_on,
      closed_on: closed_on
    }

    assert PrsTook30DaysToComplete.count(input, nil) == []
  end
end
