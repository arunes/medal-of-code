defmodule Moc.Scoring.Counters.TotalLettersCommentedOnPR do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.group_by(& &1.created_by_id)
    |> Enum.map(fn {id, list} ->
      %{
        contributor_id: id,
        count: Enum.sum_by(list, &(String.graphemes(&1.content) |> length))
      }
    end)
  end
end
