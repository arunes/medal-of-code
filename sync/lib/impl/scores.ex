defmodule Moc.Sync.Impl.Scores do
  require Logger
  import Moc.Utils.Date, only: [utc_now: 0]
  alias Moc.Db.Schema
  alias Moc.Db.Repo
  alias Moc.Sync.Impl.Calculator

  def calculate do
    Calculator.calculate()
    |> Enum.map(&insert_results/1)
  end

  defp insert_results(result_set) do
    Repo.transaction(fn ->
      result_set
      |> insert_counter_results()
      |> award_xp()
      |> update_pull_requests()
    end)
  end

  defp update_pull_requests(result_set) do
    to_insert =
      result_set.prs_ran_on
      |> Enum.map(fn pr_id ->
        %{
          counter_id: result_set.counter_id,
          pull_request_id: pr_id,
          inserted_at: utc_now(),
          updated_at: utc_now()
        }
      end)

    Repo.insert_all(Schema.PullRequestCounter, to_insert)
    result_set
  end

  defp award_xp(result_set), do: result_set

  defp insert_counter_results(result_set) do
    to_insert =
      result_set.results
      |> Enum.filter(fn r -> is_nil(r.contributor_counter_id) end)
      |> Enum.map(fn r ->
        %{
          counter_id: result_set.counter_id,
          repository_id: r.repository_id,
          contributor_id: r.contributor_id,
          count: Enum.sum_by(r.data, & &1.count),
          inserted_at: utc_now(),
          updated_at: utc_now()
        }
      end)

    Repo.insert_all(Schema.ContributorCounter, to_insert)

    # update existing
    result_set.results
    |> Enum.filter(fn r -> not is_nil(r.contributor_counter_id) end)
    |> Enum.each(fn r ->
      Repo.update(
        Ecto.Changeset.change(%Schema.ContributorCounter{id: r.contributor_counter_id},
          count: r.old_count + Enum.sum_by(r.data, & &1.count)
        )
      )
    end)

    result_set
  end
end
