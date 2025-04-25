defmodule Moc.Tests.Counters.CommentedWithExternalLinkTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedWithExternalLink
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedWithExternalLink.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedWithExternalLink.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none contain an external link" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World"},
        %{comment_type: :text, content: "This is a test"}
      ]
    }

    assert CommentedWithExternalLink.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment with an external link" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "Check out this link: https://example.com",
          created_by_id: 1
        }
      ]
    }

    assert CommentedWithExternalLink.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments with external links" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "Check out this link: https://example.com",
          created_by_id: 1
        },
        %{comment_type: :text, content: "Another link: http://example2.com", created_by_id: 2},
        %{comment_type: :text, content: "One more link: https://example3.com", created_by_id: 1}
      ]
    }

    assert CommentedWithExternalLink.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end

  test "ignores links to dev.azure.com" do
    input = %Type.Input{
      comments: [
        %{
          comment_type: :text,
          content: "Check out this link: https://dev.azure.com",
          created_by_id: 1
        }
      ]
    }

    assert CommentedWithExternalLink.count(input, nil) == []
  end
end
