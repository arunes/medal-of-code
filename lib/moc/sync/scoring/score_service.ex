defmodule Moc.Sync.Scoring.ScoreService do
  require Logger
  import Ecto.Query
  alias Moc.Repo
  alias Moc.Schema
  alias Moc.Sync.Scoring

  def calculate do
    Scoring.CounterService.get_result_sets()
    |> Enum.map(&insert_results/1)
  end

  defp insert_results(result_set) do
    Repo.transaction(fn ->
      contributors_before = query_contributors() |> Repo.all()

      result_set
      |> Scoring.SaveCounterResults.run()
      |> Scoring.AwardXP.run()
      |> Scoring.UpdatePullRequests.run()
      |> Scoring.AwardMedals.run()
      |> Scoring.SaveUpdates.run(contributors_before)
    end)
  end

  defp query_contributors do
    from(cnt in Schema.ContributorOverview)
  end
end
