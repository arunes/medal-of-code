defmodule Moc.Sync.Scoring.ScoreService do
  require Logger
  alias Moc.Repo
  alias Moc.Sync.Scoring

  def calculate do
    Scoring.CounterService.get_result_sets()
    |> Enum.map(&insert_results/1)
  end

  defp insert_results(result_set) do
    Repo.transaction(fn ->
      result_set
      |> Scoring.SaveCounterResults.run()
      |> Scoring.AwardXP.run()
      |> Scoring.UpdatePullRequests.run()
      |> Scoring.AwardMedals.run()
    end)
  end
end
