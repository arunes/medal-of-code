defmodule Moc.Scoring.Impl.ScoreService do
  require Logger
  alias Moc.Data.Repo
  alias Moc.Scoring.Impl

  def calculate do
    Impl.CounterService.get_result_sets()
    |> Enum.map(&insert_results/1)
  end

  defp insert_results(result_set) do
    Repo.transaction(fn ->
      result_set
      |> Impl.SaveCounterResults.run()
      |> Impl.AwardXP.run()
      |> Impl.UpdatePullRequests.run()
      |> Impl.AwardMedals.run()
    end)
  end
end
