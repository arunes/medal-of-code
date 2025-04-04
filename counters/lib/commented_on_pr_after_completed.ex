defmodule Moc.Counters.CommentedOnPRAfterCompleted do
  alias Moc.Counters.Type
  
  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{closed_on: closed_on, comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == "text" and
        NaiveDateTime.compare(cmt.published_on, closed_on) == :gt
    end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
