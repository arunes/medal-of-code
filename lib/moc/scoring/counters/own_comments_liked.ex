defmodule Moc.Scoring.Counters.OwnCommentsLiked do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> count_own_likes(cmt.liked_by, cmt.created_by_id) > 0 end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end

  defp count_own_likes(liked_by, author_id) do
    liked_by
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.count(&(&1 == author_id))
  end
end
