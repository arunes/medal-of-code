defmodule Moc.Tests.Counters.CommentedAsLGTMTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedAsLGTM
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedAsLGTM.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedAsLGTM.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none say exactly LGTM" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello LGTM World"},
        %{comment_type: :text, content: "hello"}
      ]
    }

    assert CommentedAsLGTM.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one LGTM comment" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "LGTM", created_by_id: 1}
      ]
    }

    assert CommentedAsLGTM.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple LGTM comments" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "LGTM", created_by_id: 1},
        %{comment_type: :text, content: "LGTM", created_by_id: 2},
        %{comment_type: :text, content: "LGTM", created_by_id: 1}
      ]
    }

    assert CommentedAsLGTM.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "returns contributors with their respective counts when there are LGTM comments with different casing" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "LGTM", created_by_id: 1},
        %{comment_type: :text, content: "lgtm", created_by_id: 2},
        %{comment_type: :text, content: "LGTm", created_by_id: 1}
      ]
    }

    assert CommentedAsLGTM.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end
end
