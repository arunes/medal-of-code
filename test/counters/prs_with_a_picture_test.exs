defmodule Moc.Tests.Counters.PrsWithAPictureTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.PrsWithAPicture
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when the description is nil" do
    input = %Type.Input{
      created_by_id: 1,
      description: nil
    }

    assert PrsWithAPicture.count(input, nil) == []
  end

  test "returns an empty list when the description doesn't contain an image" do
    input = %Type.Input{
      created_by_id: 1,
      description: "This is a description without an image"
    }

    assert PrsWithAPicture.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when the description contains a PNG image" do
    input = %Type.Input{
      created_by_id: 1,
      description: "![image.png](path_to_image.png)"
    }

    assert PrsWithAPicture.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the description contains a JPG image" do
    input = %Type.Input{
      created_by_id: 1,
      description: "![image.jpg](path_to_image.jpg)"
    }

    assert PrsWithAPicture.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the description contains a JPEG image" do
    input = %Type.Input{
      created_by_id: 1,
      description: "![image.jpeg](path_to_image.jpeg)"
    }

    assert PrsWithAPicture.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end

  test "returns a contributor with a count of 1 when the description contains a GIF image" do
    input = %Type.Input{
      created_by_id: 1,
      description: "![image.gif](path_to_image.gif)"
    }

    assert PrsWithAPicture.count(input, nil) == [
             %{contributor_id: 1, count: 1}
           ]
  end
end
