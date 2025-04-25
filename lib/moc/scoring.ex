defmodule Moc.Scoring do
  require Logger
  alias Moc.Scoring.Updates
  alias Moc.Scoring.Medals
  alias Moc.Utils
  alias Moc.Repo
  alias Moc.Scoring.Counters
  alias Moc.Contributors.ContributorXP
  alias Moc.Contributors.ContributorOverview
  alias Moc.PullRequests.PullRequestCounter

  def calculate() do
    Counters.get_result_sets()
    |> save_results()
  end

  defp save_results([]), do: :ok

  defp save_results([result_set | rest]) do
    Repo.transaction(fn ->
      contributors_before = Repo.all(ContributorOverview)

      result_set
      |> Counters.save_result_set()
      |> award_xp()
      |> update_pull_requests()
      |> Medals.award_medals()
      |> Updates.save_updates(contributors_before)
    end)

    save_results(rest)
  end

  defp award_xp(result_set) do
    Logger.info("Awarding XP for counter with id #{result_set.counter_id}")

    to_insert =
      result_set.results
      |> Enum.flat_map(fn result ->
        result.data
        |> Enum.map(fn d ->
          %{
            contributor_id: result.contributor_id,
            pull_request_id: d.pull_request_id,
            xp: d.xp,
            dark_xp: add_dark_xp(d.affinity, d.xp),
            light_xp: add_light_xp(d.affinity, d.xp),
            dexterity: d.dexterity,
            wisdom: d.wisdom,
            charisma: d.charisma,
            constitution: d.constitution,
            inserted_at: Utils.utc_now(),
            updated_at: Utils.utc_now()
          }
        end)
      end)
      |> Enum.filter(fn d -> d.xp + d.dexterity + d.wisdom + d.charisma + d.constitution > 0 end)

    Repo.insert_all(ContributorXP, to_insert)

    result_set
  end

  defp add_dark_xp("dark", xp), do: xp
  defp add_dark_xp(_, _), do: 0.0

  defp add_light_xp("dark", xp), do: xp
  defp add_light_xp(_, _), do: 0.0

  defp update_pull_requests(result_set) do
    Logger.info("Updating pull requests for counter with id #{result_set.counter_id}")

    to_insert =
      result_set.prs_ran_on
      |> Enum.map(fn pr_id ->
        %{
          counter_id: result_set.counter_id,
          pull_request_id: pr_id,
          inserted_at: Utils.utc_now(),
          updated_at: Utils.utc_now()
        }
      end)

    Repo.insert_all(PullRequestCounter, to_insert)
    result_set
  end
end
