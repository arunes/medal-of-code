defmodule Moc.Sync.Counters.CommentedAsLGTM do
  alias Moc.Sync.Counters.Helpers
  alias Moc.Sync.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == "text" and cmt.content |> String.downcase() == "lgtm"
    end)
    |> Helpers.result_by_count()
  end
end
