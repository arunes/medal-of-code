defmodule Moc.Scoring.Counters.PrsTook30DaysToComplete do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(
        %Type.Input{created_by_id: created_by_id, created_on: created_on, closed_on: closed_on},
        _get_data
      ) do
    in_30_days = DateTime.add(created_on, 30, :day)

    case DateTime.compare(closed_on, in_30_days) do
      :gt -> [%{contributor_id: created_by_id, count: 1}]
      :eq -> [%{contributor_id: created_by_id, count: 1}]
      _ -> []
    end
  end
end
