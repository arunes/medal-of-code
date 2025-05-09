defmodule Moc.Scoring.Counters.PrsRejectedByOthers do
  alias Moc.Scoring.Counters.Type

  # 10 - approved 
  # 5 - approved with suggestions
  # 0 - no vote 
  # -5 - waiting for author
  # -10 - rejected

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{reviews: reviews, created_by_id: created_by_id}, _get_data) do
    rejected? =
      reviews |> Enum.any?(fn rv -> rv.vote == -10 && rv.reviewer_id != created_by_id end)

    case rejected? do
      true -> [%{contributor_id: created_by_id, count: 1}]
      false -> []
    end
  end
end
