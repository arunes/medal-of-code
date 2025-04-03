defmodule Moc.Sync.Impl.Calculator do
  require Logger
  import Ecto.Query
  alias Moc.Sync.Type
  alias Ecto.Repo.Schema
  alias Moc.Db.Repo
  alias Moc.Db.Schema
  alias Moc.Utils

  @spec calculate() :: Type.counter_result_set()
  def calculate do
    # pulls the data to sync, every row will have id (pr id) 
    # and comma separated counter ids to run for the pr
    sync_data = get_sync_data()

    get_all_counters()
    |> Enum.map(&run_for_counter(&1, sync_data))
  end

  defp run_for_counter(counter, data) do
    Logger.info("Running for counter '#{counter.key}'")

    all_pr_ids =
      data
      |> Enum.filter(fn pr -> counter.id in pr.counter_ids end)
      |> Enum.map(fn pr -> pr.id end)

    Logger.info("'#{counter.key}' will run on #{length(all_pr_ids)} pull requests.")

    all_pr_ids
    |> query_pull_requests()
    |> Repo.all()
    |> Enum.map(&run_counter(counter, &1))
    |> Enum.filter(&(length(&1) > 0))
    |> Enum.reduce([], fn r, acc -> r ++ acc end)
    |> group_into_result_set(counter, all_pr_ids)
  end

  defp group_into_result_set(results, counter, all_pr_ids) do
    repository_ids = results |> Enum.map(fn r -> r.repository_id end) |> Enum.uniq()
    contributor_ids = results |> Enum.map(fn r -> r.contributor_id end) |> Enum.uniq()
    existing = query_existing_counter(repository_ids, contributor_ids, counter.id) |> Repo.all()

    set_results =
      results
      |> Utils.List.flatten()
      |> Enum.group_by(fn r -> {r.contributor_id, r.repository_id} end)
      |> Enum.map(fn {{contributor_id, repository_id}, data} ->
        current_count =
          existing
          |> Enum.find(%{id: nil, count: 0}, fn d ->
            d.contributor_id == contributor_id and d.repository_id == repository_id
          end)

        %{
          contributor_id: contributor_id,
          repository_id: repository_id,
          contributor_counter_id: current_count.id,
          old_count: current_count.count,
          data: data |> Enum.map(&Map.drop(&1, [:contributor_id, :repository_id]))
        }
      end)

    %{
      counter_key: counter.key,
      counter_id: counter.id,
      prs_ran_on: all_pr_ids,
      results: set_results
    }
  end

  defp run_counter(counter, pr) do
    module =
      Module.safe_concat([
        "Moc",
        "Sync",
        "Impl",
        "Counters",
        Utils.String.capitalize_first(counter.key)
      ])

    apply(module, :count, [pr])
    |> Enum.map(fn r ->
      %{
        pull_request_id: pr.id,
        repository_id: pr.repository_id,
        contributor_id: r.contributor_id,
        count: r.count,
        xp: r.count * counter.xp,
        affinity: counter.affinity,
        dexterity: r.count * counter.dexterity,
        wisdom: r.count * counter.wisdom,
        charisma: r.count * counter.charisma,
        constitution: r.count * counter.constitution
      }
    end)
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

  defp get_all_counters(), do: query_counters() |> Repo.all()

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

  defp query_existing_counter(repository_ids, contributor_ids, counter_id) do
    from(cc in Schema.ContributorCounter,
      where: cc.repository_id in ^repository_ids,
      where: cc.contributor_id in ^contributor_ids,
      where: cc.counter_id == ^counter_id,
      select: %{
        id: cc.id,
        contributor_id: cc.contributor_id,
        repository_id: cc.repository_id,
        count: cc.count
      }
    )
  end
end
