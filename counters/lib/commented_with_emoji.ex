defmodule Moc.Counters.CommentedWithEmoji do
  alias Moc.Counters.Helpers
  alias Moc.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == "text" && has_emoji?(cmt.content) end)
    |> Helpers.result_by_count()
  end

  defp has_emoji?(comment) do
    length(Emojix.scan(comment)) > 0
  end
end
