defmodule Moc.Counters.CommentedWithPicture do
  alias Moc.Counters.Type
  
  @regex ~r/!\[.+(png|jpg|jpeg|gif)\]/

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == "text" && cmt.content =~ @regex end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
