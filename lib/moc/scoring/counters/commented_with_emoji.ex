defmodule Moc.Scoring.Counters.CommentedWithEmoji do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == :text && has_emoji?(cmt.content) end)
    |> Helpers.result_by_comment_count()
  end

  defp has_emoji?(comment) do
    length(Emojix.scan(comment)) > 0
  end
end
