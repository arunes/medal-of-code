defmodule Moc.Scoring.Counters.CommentedWithCodeChangeSuggestion do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == :text && cmt.content =~ "```suggestion" end)
    |> Helpers.result_by_comment_count()
  end
end
