defmodule Moc.Counters.CommentLikedByOthers do
  alias Moc.Counters.Helpers
  alias Moc.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == "text" and &1.liked_by != ""))
    |> Enum.map(fn cmt ->
      %{contributor_id: cmt.created_by_id, count: count_likes(cmt.liked_by, cmt.created_by_id)}
    end)
    |> Helpers.result_by_sum()
  end

  defp count_likes(liked_by, author_id) do
    liked_by
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.count(&(&1 != author_id))
  end
end
