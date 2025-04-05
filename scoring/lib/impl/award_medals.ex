defmodule Moc.Scoring.Impl.AwardMedals do
  import Moc.Utils.Date, only: [utc_now: 0]
  require Logger
  alias Moc.Data.Repo
  alias Moc.Data.Schema
  alias Moc.Scoring.Type
  alias Moc.Data.Runtime.MedalCache

  @spec run(Type.result_set()) :: Type.result_set()
  def run(result_set) do
    Logger.info("Awarding Medals for counter with id #{result_set.counter_id}")

    result_set |> get_winners() |> insert_to_db()
    result_set
  end

  defp get_winners(result_set) do
    winners =
      for medal <- MedalCache.get_by_counter_id(result_set.counter_id),
          result <- result_set.results,
          do: calculate(medal, result)

    winners |> Enum.flat_map(& &1)
  end

  defp calculate(medal, result) do
    old_count = result.old_count
    new_count = result.data |> Enum.sum_by(& &1.count)
    already_won = (old_count / medal.count_to_award) |> trunc()
    total_won = (new_count / medal.count_to_award) |> trunc()
    medals_won = how_many_won(total_won - already_won)

    get_maps(medals_won, result.contributor_id, medal.id)
  end

  defp how_many_won(count) when count < 0, do: 0
  defp how_many_won(count), do: count

  defp get_maps(0, _contributor_id, _medal_id), do: []

  defp get_maps(medals_won, contributor_id, medal_id) do
    1..medals_won
    |> Enum.map(fn _ ->
      %{
        contributor_id: contributor_id,
        medal_id: medal_id,
        inserted_at: utc_now(),
        updated_at: utc_now()
      }
    end)
  end

  defp insert_to_db([]), do: {:ok, []}
  defp insert_to_db(winners), do: Repo.insert_all(Schema.ContributorMedal, winners)
end
