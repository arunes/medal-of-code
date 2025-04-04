defmodule Moc.Counters.CommentedOnPRAfterCompleted do
  alias Moc.Counters.Helpers
  alias Moc.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{closed_on: closed_on, comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == "text" and
        NaiveDateTime.compare(cmt.published_on, closed_on) == :gt
    end)
    |> Helpers.result_by_count()
  end
end
