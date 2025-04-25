defmodule Moc.Scoring.Counters do
  import Ecto.Query
  require Logger
  alias Moc.Contributors.ContributorCache
  alias Moc.Contributors.ContributorCounter
  alias Moc.Utils
  alias Moc.Repo
  alias Moc.Scoring.Counter
  alias Moc.PullRequests.PullRequest
  alias Moc.PullRequests.PullRequestCounter

  def get_result_sets() do
    # pulls the data to sync, every row will have id (pr id) 
    # and comma separated counter ids to run for the pr
    pull_requests = get_pull_requests()

    Counter
    |> Repo.all()
    |> Enum.filter(fn cnt ->
      pull_requests |> Enum.any?(fn pr -> cnt.id in pr.counter_ids end)
    end)
    |> Enum.map(fn cnt ->
      pr_ids =
        pull_requests
        |> Enum.filter(fn pr -> cnt.id in pr.counter_ids end)
        |> Enum.map(& &1.pr_id)

      {cnt, pr_ids}
    end)
    |> run_counters()
  end

  defp run_counters(data, result \\ [])
  defp run_counters([], result), do: result

  defp run_counters([{counter, pr_ids} | rest], result) do
    Logger.info("Running for counter '#{counter.key}' for #{length(pr_ids)} pull requests.")

    counter_result =
      pr_ids
      |> get_pull_requests()
      |> run_counter_impl(counter)
      |> Enum.filter(&(length(&1) > 0))
      |> Enum.reduce([], fn r, acc -> r ++ acc end)
      |> group_into_result_set(counter, pr_ids)

    run_counters(rest, [counter_result | result])
  end

  def save_result_set(result_set) do
    Logger.info("Saving counter results for counter with id #{result_set.counter_id}")

    to_insert =
      result_set.results
      |> Enum.filter(fn r -> is_nil(r.contributor_counter_id) end)
      |> Enum.map(fn r ->
        %{
          counter_id: result_set.counter_id,
          repository_id: r.repository_id,
          contributor_id: r.contributor_id,
          count: Enum.sum_by(r.data, & &1.count),
          inserted_at: Utils.utc_now(),
          updated_at: Utils.utc_now()
        }
      end)

    Repo.insert_all(ContributorCounter, to_insert)

    # update existing
    result_set.results
    |> Enum.filter(fn r -> not is_nil(r.contributor_counter_id) end)
    |> Enum.each(fn r ->
      Repo.update(
        Ecto.Changeset.change(%ContributorCounter{id: r.contributor_counter_id},
          count: r.old_count + Enum.sum_by(r.data, & &1.count)
        )
      )
    end)

    result_set
  end

  defp group_into_result_set(results, counter, all_pr_ids) do
    repository_ids = results |> Enum.map(fn r -> r.repository_id end) |> Enum.uniq()
    contributor_ids = results |> Enum.map(fn r -> r.contributor_id end) |> Enum.uniq()

    existing =
      from(cc in ContributorCounter,
        where: cc.repository_id in ^repository_ids,
        where: cc.contributor_id in ^contributor_ids,
        where: cc.counter_id == ^counter.id,
        select: %{
          id: cc.id,
          contributor_id: cc.contributor_id,
          repository_id: cc.repository_id,
          count: cc.count
        }
      )
      |> Repo.all()

    set_results =
      results
      |> Utils.flatten()
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

  defp run_counter_impl(prs, counter, result \\ [])
  defp run_counter_impl([], _counter, result), do: result

  defp run_counter_impl([pr | rest], counter, result) do
    module =
      Module.safe_concat([
        "Moc",
        "Scoring",
        "Counters",
        Utils.capitalize_first(counter.key)
      ])

    input = struct(Moc.Scoring.Counters.Type.Input, Map.from_struct(pr))

    # run implementation
    counter_result =
      apply(module, :count, [input, &counter_data_provider/2])
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

    run_counter_impl(rest, counter, [counter_result | result])
  end

  defp counter_data_provider(:contributor_by_id, contributor_id) do
    ContributorCache.get_by_id(contributor_id)
  end

  defp get_pull_requests(pr_ids) do
    from(pr in PullRequest,
      where: pr.id in ^pr_ids,
      preload: [:reviews, :comments]
    )
    |> Repo.all()
  end

  defp get_pull_requests do
    from(pr in PullRequest,
      as: :pr_list,
      join: rp in assoc(pr, :repository),
      join: prj in assoc(rp, :project),
      join: org in assoc(prj, :organization),
      join: cnt in Counter,
      as: :cnt_list,
      on: true,
      group_by: [pr.id],
      where:
        not exists(
          from(
            prc in PullRequestCounter,
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
    |> Repo.all()
    |> Enum.map(fn d ->
      %{
        pr_id: d.id,
        counter_ids: d.counter_ids |> String.split(",") |> Enum.map(&String.to_integer/1)
      }
    end)
  end
end
