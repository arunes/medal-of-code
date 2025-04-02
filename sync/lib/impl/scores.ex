defmodule Moc.Sync.Impl.Scores do
  require Logger
  import Moc.Utils.Date, only: [utc_now: 0]
  alias Moc.Db.Schema
  alias Moc.Db.Repo
  alias Moc.Sync.Impl.Calculator
  alias Moc.Sync.Runtime.ScoreCache
  alias Moc.Sync.Runtime.GenericCache

  def calculate do
    # Calculate counters
    Calculator.calculate()
    |> insert_results()

    # Award medals

    # Create updates

    # Clean-up
    GenericCache.purge()
    ScoreCache.purge()
  end

  defp insert_results(results) do
    Repo.transaction(fn ->
      entries =
        results
        |> Enum.map(fn result ->
          %{
            counter_id: result.counter_id,
            repository_id: result.repository_id,
            contributor_id: result.contributor_id,
            count: result.data |> Enum.sum_by(fn r -> r.count end),
            inserted_at: utc_now(),
            updated_at: utc_now()
          }
        end)

      IO.inspect(entries)

      Repo.insert_all(Schema.ContributorCounter, entries)
      |> IO.inspect()

      nil
    end)
  end
end
