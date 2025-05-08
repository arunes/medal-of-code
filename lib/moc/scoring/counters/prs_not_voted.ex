defmodule Moc.Scoring.Counters.PrsNotVoted do
  alias Moc.Scoring.Counters.Type

  # 10 - approved 
  # 5 - approved with suggestions
  # 0 - no vote 
  # -5 - waiting for author
  # -10 - rejected

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{reviews: reviews}, _get_data) do
    reviews
    |> Enum.filter(&(&1.vote == 0))
    |> Enum.map(&%{contributor_id: &1.reviewer_id, count: 1})
  end
end
