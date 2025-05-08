defmodule Moc.Scoring.Counters.PrsAbandonedIn10Minutes do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(
        %Type.Input{
          status: status,
          created_by_id: created_by_id,
          created_on: created_on,
          closed_on: closed_on
        },
        _get_data
      ) do
    ten_mins_later = DateTime.add(created_on, 10 * 60)

    cond do
      status == :abandoned && DateTime.compare(ten_mins_later, closed_on) == :gt ->
        [%{contributor_id: created_by_id, count: 1}]

      true ->
        []
    end
  end
end
