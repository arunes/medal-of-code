defmodule Moc.Tests.Counters.Commented15TimesOnSamePRTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.Commented15TimesOnSamePR
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert Commented15TimesOnSamePR.count(input, fn -> nil end) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: "image"}]}
    assert Commented15TimesOnSamePR.count(input, fn -> nil end) == []
  end

  test "returns an empty list when there are less than 15 text comments from a contributor" do
    input = %Type.Input{
      comments: Enum.map(1..14, fn _ -> %{comment_type: :text, created_by_id: 1} end)
    }

    assert Commented15TimesOnSamePR.count(input, fn -> nil end) == []
  end

  test "returns a single contributor with a count of 1 when there are 15 or more text comments from a contributor" do
    input = %Type.Input{
      comments: Enum.map(1..15, fn _ -> %{comment_type: :text, created_by_id: 1} end)
    }

    assert Commented15TimesOnSamePR.count(input, fn -> nil end) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple contributors with 15 or more text comments" do
    input = %Type.Input{
      comments:
        Enum.map(1..15, fn _ -> %{comment_type: :text, created_by_id: 1} end) ++
          Enum.map(1..15, fn _ -> %{comment_type: :text, created_by_id: 2} end)
    }

    assert Commented15TimesOnSamePR.count(input, fn -> nil end) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end
end
