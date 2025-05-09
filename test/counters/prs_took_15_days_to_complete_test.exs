defmodule Moc.Tests.Counters.PrsTook15DaysToCompleteTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsTook15DaysToComplete
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is completed within 15 days" do
    created_on = ~U[2022-01-01 00:00:00Z]
    closed_on = ~U[2022-01-15 00:00:00Z]

    input = %Type.Input{
      created_by_id: 1,
      created_on: created_on,
      closed_on: closed_on
    }

    assert PrsTook15DaysToComplete.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR takes more than 15 days to complete" do
    created_on = ~U[2022-01-01 00:00:00Z]
    closed_on = ~U[2022-01-16 00:00:00Z]

    input = %Type.Input{
      created_by_id: 1,
      created_on: created_on,
      closed_on: closed_on
    }

    assert PrsTook15DaysToComplete.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns an empty list when the PR is completed on the 14th day" do
    created_on = ~U[2022-01-01 00:00:00Z]
    closed_on = DateTime.add(created_on, 14 * 24 * 60 * 60, :second)

    input = %Type.Input{
      created_by_id: 1,
      created_on: created_on,
      closed_on: closed_on
    }

    assert PrsTook15DaysToComplete.count(input, nil) == []
  end
end
