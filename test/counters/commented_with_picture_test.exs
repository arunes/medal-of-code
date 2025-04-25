defmodule Moc.Tests.Counters.CommentedWithPictureTest do
  use ExUnit.Case

  alias Moc.Scoring.Counters.CommentedWithPicture
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments" do
    input = %Type.Input{comments: []}
    assert CommentedWithPicture.count(input, nil) == []
  end

  test "returns an empty list when there are no text comments" do
    input = %Type.Input{comments: [%{comment_type: :system}]}
    assert CommentedWithPicture.count(input, nil) == []
  end

  test "returns an empty list when there are text comments but none contain a picture" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "Hello World"},
        %{comment_type: :text, content: "This is a test"}
      ]
    }

    assert CommentedWithPicture.count(input, nil) == []
  end

  test "returns a single contributor with a count of 1 when there is one text comment with a picture" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "![image.png](image.png)", created_by_id: 1}
      ]
    }

    assert CommentedWithPicture.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns multiple contributors with their respective counts when there are multiple text comments with pictures" do
    input = %Type.Input{
      comments: [
        %{comment_type: :text, content: "![image.png](image.png)", created_by_id: 1},
        %{
          comment_type: :text,
          content: "![another image.jpg](another_image.jpg)",
          created_by_id: 2
        },
        %{
          comment_type: :text,
          content: "![one more image.gif](one_more_image.gif)",
          created_by_id: 1
        }
      ]
    }

    assert CommentedWithPicture.count(input, nil) == [
             %{contributor_id: 1, count: 2},
             %{contributor_id: 2, count: 1}
           ]
  end
end
