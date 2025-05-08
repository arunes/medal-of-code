defmodule Moc.Scoring.Counters.OwnPRsRejected do
  alias Moc.Scoring.Counters.Type

  # 10 - approved 
  # 5 - approved with suggestions
  # 0 - no vote 
  # -5 - waiting for author
  # -10 - rejected

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, reviews: reviews}, _get_data) do
    reviews
    |> Enum.filter(fn rv -> rv.vote < 0 && rv.reviewer_id == created_by_id end)
    |> Enum.map(fn rv -> %{contributor_id: rv.reviewer_id, count: 1} end)
  end
end
