defmodule Moc.Scoring.Counters.PrsCompleted do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{status: status, created_by_id: created_by_id}, _get_data) do
    case status do
      :completed -> [%{contributor_id: created_by_id, count: 1}]
      _ -> []
    end
  end
end
