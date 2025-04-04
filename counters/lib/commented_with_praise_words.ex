defmodule Moc.Counters.CommentedWithPraiseWords do
  alias Moc.Counters.Type
  
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
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end

  defp has_praise_word(comment) do
    comment.comment_type == "text" and Enum.any?(@praise_words, fn w -> comment.content =~ w end)
  end
end
