defmodule Moc.Tests.Counters.PrsInteractedOnWeekendTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsInteractedOnWeekend
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no weekend interactions" do
    input = %Type.Input{
      created_by_id: 1,
      created_on: ~D[2022-01-03],
      closed_on: ~D[2022-01-04],
      comments: [
        %{published_on: ~D[2022-01-03], created_by_id: 2},
        %{published_on: ~D[2022-01-04], created_by_id: 3}
      ]
    }

    assert PrsInteractedOnWeekend.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR is created on a weekend" do
    input = %Type.Input{
      created_by_id: 1,
      created_on: ~D[2022-01-01],
      closed_on: ~D[2022-01-04],
      comments: []
    }

    assert PrsInteractedOnWeekend.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the PR is closed on a weekend" do
    input = %Type.Input{
      created_by_id: 1,
      created_on: ~D[2022-01-03],
      closed_on: ~D[2022-01-02],
      comments: []
    }

    assert PrsInteractedOnWeekend.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns contributors with a count of 1 when there are comments on a weekend" do
    input = %Type.Input{
      created_by_id: 1,
      created_on: ~D[2022-01-03],
      closed_on: ~D[2022-01-04],
      comments: [
        %{published_on: ~D[2022-01-01], created_by_id: 2},
        %{published_on: ~D[2022-01-02], created_by_id: 3}
      ]
    }

    assert PrsInteractedOnWeekend.count(input, nil) == [
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1}
           ]
  end

  test "returns the PR creator and commenters with a count of 1 when there are weekend interactions" do
    input = %Type.Input{
      created_by_id: 1,
      created_on: ~D[2022-01-03],
      closed_on: ~D[2022-01-04],
      comments: [
        %{published_on: ~D[2022-01-01], created_by_id: 2},
        %{published_on: ~D[2022-01-02], created_by_id: 3}
      ]
    }

    input = %{input | created_on: ~D[2022-01-01]}

    assert PrsInteractedOnWeekend.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1},
             %{contributor_id: 3, count: 1}
           ]
  end
end
