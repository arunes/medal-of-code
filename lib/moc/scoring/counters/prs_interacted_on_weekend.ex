defmodule Moc.Scoring.Counters.PrsInteractedOnWeekend do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(
        %Type.Input{
          created_by_id: created_by_id,
          created_on: created_on,
          closed_on: closed_on,
          comments: comments
        },
        _get_data
      ) do
    comments
    |> get_commenters()
    |> get_pr_creator(created_by_id, created_on, closed_on)
  end

  defp get_pr_creator(results, created_by_id, created_on, closed_on) do
    created_day = Date.day_of_week(created_on)
    closed_day = Date.day_of_week(closed_on)

    cond do
      created_day == 6 || created_day == 7 || closed_day == 6 || closed_day == 7 ->
        [%{contributor_id: created_by_id, count: 1} | results]

      true ->
        results
    end
  end

  defp get_commenters(comments) do
    Enum.filter(comments, fn cmt ->
      Date.day_of_week(cmt.published_on) == 6 ||
        Date.day_of_week(cmt.published_on) == 7
    end)
    |> Enum.map(& &1.created_by_id)
    |> Enum.uniq()
    |> Enum.map(&%{contributor_id: &1, count: 1})
  end
end
