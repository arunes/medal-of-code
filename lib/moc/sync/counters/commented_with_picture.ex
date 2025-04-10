defmodule Moc.Sync.Counters.CommentedWithPicture do
  alias Moc.Sync.Counters.Helpers
  alias Moc.Sync.Counters.Type

  @regex ~r/!\[.+(png|jpg|jpeg|gif)\]/

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == "text" && cmt.content =~ @regex end)
    |> Helpers.result_by_count()
  end
end
