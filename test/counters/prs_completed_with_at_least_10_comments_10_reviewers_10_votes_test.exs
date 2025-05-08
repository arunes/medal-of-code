defmodule Moc.Tests.Counters.PrsCompletedWithAtLeast10Comments10Reviewers10VotesTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsCompletedWithAtLeast10Comments10Reviewers10Votes
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the PR is not completed" do
    input = %Type.Input{
      status: :open,
      created_by_id: 1,
      comments: Enum.map(1..10, fn _ -> %{comment_type: :text} end),
      reviews: Enum.map(1..10, fn i -> %{vote: if(i > 1, do: 1, else: 0)} end)
    }

    assert PrsCompletedWithAtLeast10Comments10Reviewers10Votes.count(input, nil) == []
  end

  test "returns an empty list when there are less than 10 comments" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      comments: Enum.map(1..9, fn _ -> %{comment_type: :text} end),
      reviews: Enum.map(1..10, fn i -> %{vote: if(i > 1, do: 1, else: 0)} end)
    }

    assert PrsCompletedWithAtLeast10Comments10Reviewers10Votes.count(input, nil) == []
  end

  test "returns an empty list when there are less than 10 reviews" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      comments: Enum.map(1..10, fn _ -> %{comment_type: :text} end),
      reviews: Enum.map(1..9, fn i -> %{vote: if(i > 1, do: 1, else: 0)} end)
    }

    assert PrsCompletedWithAtLeast10Comments10Reviewers10Votes.count(input, nil) == []
  end

  test "returns an empty list when there are less than 10 votes" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      comments: Enum.map(1..10, fn _ -> %{comment_type: :text} end),
      reviews: Enum.map(1..10, fn _ -> %{vote: 0} end)
    }

    assert PrsCompletedWithAtLeast10Comments10Reviewers10Votes.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the PR meets all the conditions" do
    input = %Type.Input{
      status: :completed,
      created_by_id: 1,
      comments: Enum.map(1..10, fn _ -> %{comment_type: :text} end),
      reviews: Enum.map(1..10, fn _ -> %{vote: 1} end)
    }

    assert PrsCompletedWithAtLeast10Comments10Reviewers10Votes.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
