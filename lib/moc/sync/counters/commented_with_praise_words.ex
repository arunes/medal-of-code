defmodule Moc.Sync.Counters.CommentedWithPraiseWords do
  alias Moc.Sync.Counters.Helpers
  alias Moc.Sync.Counters.Type

  @praise_words [
    "awesome",
    "great",
    "cool",
    "amazing",
    "fantastic",
    "excellent",
    "outstanding",
    "superb",
    "phenomenal",
    "stellar",
    "kudos"
  ]

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&has_praise_word/1)
    |> Helpers.result_by_count()
  end

  defp has_praise_word(comment) do
    comment.comment_type == "text" and
      Enum.any?(@praise_words, fn w -> String.downcase(comment.content) =~ w end)
  end
end
