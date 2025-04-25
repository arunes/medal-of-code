defmodule Moc.Scoring.Counters.Commented10TimesOnSamePR do
  alias Moc.Scoring.Counters.Type
  
  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.map(fn comment ->
      number_of_comments =
        comments
        |> Enum.count(&(&1.comment_type == :text and &1.created_by_id == comment.created_by_id))

      %{contributor_id: comment.created_by_id, total_comments: number_of_comments}
    end)
    |> Enum.filter(&(&1.total_comments >= 10))
    |> Enum.map(& &1.contributor_id)
    |> Enum.uniq()
    |> Enum.map(fn contributor_id -> %{contributor_id: contributor_id, count: 1} end)
  end
end
