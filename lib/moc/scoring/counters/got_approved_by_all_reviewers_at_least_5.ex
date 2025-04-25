defmodule Moc.Scoring.Counters.GotApprovedByAllReviewersAtLeast5 do
  alias Moc.Scoring.Counters.Type

  # 10 - approved 
  # 5 - approved with suggestions
  # 0 - no vote 
  # -5 - waiting for author
  # -10 - rejected

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, reviews: reviews}, _get_data) do
    reviews
    |> Enum.filter(fn rv -> rv.reviewer_id != created_by_id && rv.vote > 0 end)
    |> length()
    |> set_response(created_by_id)
  end

  defp set_response(count, _id) when count < 5, do: []
  defp set_response(_count, id), do: [%{contributor_id: id, count: 1}]
end
