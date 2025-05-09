defmodule Moc.Scoring.Counters.RequiredReviewersAdded do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, reviews: reviews}, _get_data) do
    [%{contributor_id: created_by_id, count: Enum.count(reviews, & &1.is_required)}]
  end
end
