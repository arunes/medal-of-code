defmodule Moc.Scoring.Counters.PrsCompletedWithNoReviewers do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(
        %Type.Input{created_by_id: created_by_id, status: status, reviews: reviews},
        _get_data
      ) do
    match? = status == :completed && length(reviews) == 0

    case match? do
      true -> [%{contributor_id: created_by_id, count: 1}]
      false -> []
    end
  end
end
