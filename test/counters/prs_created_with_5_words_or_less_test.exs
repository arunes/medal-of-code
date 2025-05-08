defmodule Moc.Tests.Counters.PrsCreatedWith5WordsOrLessTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsCreatedWith5WordsOrLess
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the description has more than 5 words" do
    input = %Type.Input{
      created_by_id: 1,
      description: "This is a long description with many words"
    }

    assert PrsCreatedWith5WordsOrLess.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the description has 5 words or less" do
    input = %Type.Input{
      created_by_id: 1,
      description: "This is a short description"
    }

    assert PrsCreatedWith5WordsOrLess.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the description has exactly 5 words" do
    input = %Type.Input{
      created_by_id: 1,
      description: "This is a short desc"
    }

    assert PrsCreatedWith5WordsOrLess.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the description is nil" do
    input = %Type.Input{
      created_by_id: 1,
      description: nil
    }

    assert PrsCreatedWith5WordsOrLess.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the description is a single word" do
    input = %Type.Input{
      created_by_id: 1,
      description: "Fix"
    }

    assert PrsCreatedWith5WordsOrLess.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
