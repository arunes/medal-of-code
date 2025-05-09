defmodule Moc.Scoring.Counters.PrsWithAtLeast10Reviewers do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, reviews: reviews}, _get_data) do
    cond do
      length(reviews) >= 10 -> [%{contributor_id: created_by_id, count: 1}]
      true -> []
    end
  end
end
