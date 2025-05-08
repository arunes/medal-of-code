defmodule Moc.Scoring.Counters.CommentedOnPRAfterCompleted do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{closed_on: closed_on, comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == :text and
        DateTime.compare(cmt.published_on, closed_on) == :gt
    end)
    |> Helpers.result_by_comment_count()
  end
end
