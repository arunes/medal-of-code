defmodule Moc.Sync.Impl.Scores do
  require Logger
  import Ecto.Query
  alias Moc.Sync.Impl.Counter
  alias Moc.Sync.Runtime.GenericCache
  alias Ecto.Repo.Schema
  alias Moc.Db.Repo
  alias Moc.Db.Schema

  def calculate do
    sync_data = get_sync_data()

    query_counters()
    |> Repo.all()
    |> Enum.map(&run_for_counter(&1, sync_data))
  end

  defp get_sync_data do
    query_score_data()
    |> Repo.all()
    |> Enum.map(fn d ->
      %{
        id: d.id,
        counter_ids: d.counter_ids |> String.split(",") |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  defp run_for_counter(counter, data) do
    Logger.info("Running for counter '#{counter.key}'")

    all_pr_ids =
      data
      |> Enum.filter(fn pr -> counter.id in pr.counter_ids end)
      |> Enum.map(fn pr -> pr.id end)

    Logger.info("'#{counter.key}' will run on #{length(all_pr_ids)} pull requests.")
    db_pr_ids = all_pr_ids |> Enum.filter(&(not GenericCache.has_key?("pr_#{&1}")))

    Logger.info(
      "#{length(db_pr_ids)} out of #{length(all_pr_ids)} pull requests will be pulled from db, rest are in the cache."
    )

    db_pr_ids
    |> query_pull_requests()
    |> Repo.all()
    |> Enum.each(&GenericCache.set(&1, "pr_#{&1.id}"))

    all_pr_ids
    |> Enum.map(&GenericCache.get("pr_#{&1}", fn -> nil end))
    |> Enum.filter(&(not is_nil(&1)))
    |> Enum.map(fn pr ->
      Counter.count(counter.key, pr) |> IO.inspect()
    end)

    Logger.info("Prs to work on #{inspect(all_pr_ids)}")
  end

  # Queries
  defp query_counters() do
    from(c in Schema.Counter,
      select: %{
        id: c.id,
        key: c.key,
        xp: c.xp,
        affinity: c.affinity,
        dexterity: c.dexterity,
        wisdom: c.wisdom,
        charisma: c.charisma,
        constitution: c.constitution
      }
    )
  end

  defp query_pull_requests(pr_ids) do
    from(pr in Schema.PullRequest,
      where: pr.id in ^pr_ids,
      preload: [:reviews, :comments]
    )
  end

  defp query_score_data do
    from(pr in Schema.PullRequest,
      as: :pr_list,
      join: rp in assoc(pr, :repository),
      join: prj in assoc(rp, :project),
      join: org in assoc(prj, :organization),
      join: cnt in Schema.Counter,
      as: :cnt_list,
      on: true,
      group_by: [pr.id],
      where:
        not exists(
          from(
            prc in Schema.PullRequestCounter,
            where: parent_as(:pr_list).id == prc.pull_request_id,
            where: parent_as(:cnt_list).id == prc.counter_id,
            select: 1
          )
        ),
      select: %{
        id: pr.id,
        counter_ids: fragment("GROUP_CONCAT(?)", cnt.id)
      }
    )
  end
end
