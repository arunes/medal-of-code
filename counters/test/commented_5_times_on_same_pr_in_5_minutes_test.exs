defmodule Moc.Tests.Counters.Commented5TimesOnSamePRIn5MinutesTest do
  use ExUnit.Case

  alias Moc.Counters.Commented5TimesOnSamePRIn5Minutes
  alias Moc.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert Commented5TimesOnSamePRIn5Minutes.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: "system"}]}
    assert Commented5TimesOnSamePRIn5Minutes.count(input, nil) == []
  end

  test "returns an empty list when there are less than 5 text comments from a contributor within 5 minutes" do
    input = %Type.Input{
      comments: [
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:00:00]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:00:30]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:01:00]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:01:30]}
      ]
    }

    assert Commented5TimesOnSamePRIn5Minutes.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there are 5 or more text comments from a contributor within 5 minutes" do
    input = %Type.Input{
      comments: [
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:00:00]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:00:30]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:01:00]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:01:30]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:02:00]}
      ]
    }

    assert Commented5TimesOnSamePRIn5Minutes.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple contributors with 5 or more text comments within 5 minutes" do
    input = %Type.Input{
      comments: [
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:00:00]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:00:30]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:01:00]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:01:30]},
        %{comment_type: "text", created_by_id: 1, published_on: ~N[2022-01-01 12:02:00]},
        %{comment_type: "text", created_by_id: 2, published_on: ~N[2022-01-01 12:03:00]},
        %{comment_type: "text", created_by_id: 2, published_on: ~N[2022-01-01 12:03:30]},
        %{comment_type: "text", created_by_id: 2, published_on: ~N[2022-01-01 12:04:00]},
        %{comment_type: "text", created_by_id: 2, published_on: ~N[2022-01-01 12:04:30]},
        %{comment_type: "text", created_by_id: 2, published_on: ~N[2022-01-01 12:05:00]}
      ]
    }

    assert Commented5TimesOnSamePRIn5Minutes.count(input, nil) == [
             %{contributor_id: 1, count: 1},
             %{contributor_id: 2, count: 1}
           ]
  end
end
