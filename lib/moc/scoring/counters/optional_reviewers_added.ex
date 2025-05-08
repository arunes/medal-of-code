defmodule Moc.Scoring.Counters.OptionalReviewersAdded do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, reviews: reviews}, _get_data) do
    [
      %{
        contributor_id: created_by_id,
        count: reviews |> Enum.count(fn rv -> !rv.is_required end)
      }
    ]
  end
end
