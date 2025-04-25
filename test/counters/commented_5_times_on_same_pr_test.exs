defmodule Moc.Tests.Counters.Commented5TimesOnSamePRTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.Commented5TimesOnSamePR
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert Commented5TimesOnSamePR.count(input, fn -> nil end) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert Commented5TimesOnSamePR.count(input, fn -> nil end) == []
  end

  test "returns an empty list when there are less than 5 text comments from a contributor" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1}
      ]
    }

    assert Commented5TimesOnSamePR.count(input, fn -> nil end) == []
  end

  test "returns a single contributor with a count of 1 when there are 5 or more text comments from a contributor" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1}
      ]
    }

    assert Commented5TimesOnSamePR.count(input, fn -> nil end) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple contributors with 5 or more text comments" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 1},
        %{comment_type: :text, created_by_id: 2},
        %{comment_type: :text, created_by_id: 2},
        %{comment_type: :text, created_by_id: 2},
        %{comment_type: :text, created_by_id: 2},
        %{comment_type: :text, created_by_id: 2}
      ]
    }

    assert Commented5TimesOnSamePR.count(input, fn -> nil end) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end
end
