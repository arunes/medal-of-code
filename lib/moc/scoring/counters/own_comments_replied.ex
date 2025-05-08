defmodule Moc.Scoring.Counters.OwnCommentsReplied do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.sort_by(& &1.inserted_at)
    |> Enum.group_by(fn cmt -> cmt.thread_id end)
    |> Enum.flat_map(fn {_, t_comments} ->
      t_comments
      |> Enum.map(& &1.created_by_id)
      |> Enum.chunk_every(2, 1)
      |> Enum.filter(&(length(&1) == 2))
      |> Enum.filter(fn [a, b] -> a == b end)
      |> Enum.map(&Enum.at(&1, 0))
    end)
    |> Enum.uniq()
    |> Enum.map(&%{contributor_id: &1, count: 1})
  end
end
