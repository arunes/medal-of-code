defmodule Moc.Scoring do
  require Logger
  import Ecto.Query
  alias Moc.Contributors.ContributorMedal
  alias Moc.Contributors.Contributor
  alias Moc.Scoring.Medal
  alias Moc.Contributors.ContributorCounter
  alias Moc.Scoring.Counter
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

  def get_medal(medal_id) do
    from(mdl in Medal,
      left_join: cm in ContributorMedal,
      on: mdl.id == cm.medal_id,
      where: mdl.id == ^medal_id,
      select: %{
        id: mdl.id,
        name: mdl.name,
        description: mdl.description,
        affinity: mdl.affinity,
        lore: mdl.lore,
        medal_count: count(cm.id),
        contributors_have: count(fragment("DISTINCT ?", cm.contributor_id))
      }
    )
    |> Repo.one()
    |> maybe_populate_medal_details()
  end

  def get_medal_winners(medal_id) do
    winners =
      from(cm in ContributorMedal,
        where: cm.medal_id == ^medal_id,
        group_by: [cm.contributor_id],
        select: %{id: cm.contributor_id, count: count(cm.id)}
      )
      |> Repo.all()

    ids = winners |> Enum.map(& &1.id)

    from(co in ContributorOverview,
      where: co.id in ^ids
    )
    |> Repo.all()
    |> Enum.map(fn co ->
      %{co | number_of_medals: get_contributor_medal_count(winners, co.id)}
    end)
    |> Enum.sort_by(& &1.number_of_medals, :desc)
  end

  defp get_contributor_medal_count(list_of_winners, contributor_id) do
    case list_of_winners |> Enum.find(&(&1.id == contributor_id)) do
      nil -> 0
      w -> w.count
    end
  end

  defp maybe_populate_medal_details(nil), do: nil

  defp maybe_populate_medal_details(medal) do
    contributor_count = from(c in Contributor, select: count(c.id)) |> Repo.one!()
    rarity_percentage = medal.contributors_have / contributor_count * 100.0

    medal
    |> Map.put(:rarity_percentage, rarity_percentage)
    |> Map.put(:rarity, Utils.get_rarity(rarity_percentage))
  end

  def get_counter_list(nil) do
    from(cnt in Counter,
      where: cnt.is_main_counter,
      left_join: cc in ContributorCounter,
      on: cc.counter_id == cnt.id,
      group_by: [cnt.id, cnt.main_description, cnt.category, cnt.display_order],
      select: %{
        id: cnt.id,
        description: cnt.main_description,
        category: cnt.category,
        display_order: cnt.display_order,
        count: coalesce(sum(cc.count), 0)
      },
      order_by: cnt.display_order
    )
    |> Repo.all()
  end

  def get_counter_list(contributor_id) do
    from(cnt in Counter,
      where: cnt.is_personal_counter,
      left_join: cc in ContributorCounter,
      on: cc.counter_id == cnt.id and cc.contributor_id == ^contributor_id,
      group_by: [cnt.id, cnt.personal_description, cnt.category, cnt.display_order],
      select: %{
        id: cnt.id,
        description: cnt.personal_description,
        category: cnt.category,
        display_order: cnt.display_order,
        count: coalesce(sum(cc.count), 0)
      },
      order_by: cnt.display_order
    )
    |> Repo.all()
  end

  def get_medal_list() do
    contributor_count = from(c in Contributor, select: count(c.id)) |> Repo.one!()

    from(mdl in Medal,
      left_join: cm in ContributorMedal,
      on: mdl.id == cm.medal_id,
      group_by: [mdl.id, mdl.name, mdl.description, mdl.affinity],
      select: %{
        id: mdl.id,
        name: mdl.name,
        description: mdl.description,
        affinity: mdl.affinity,
        total: count(cm.id),
        contributors_have: count(fragment("DISTINCT ?", cm.contributor_id)),
        last_won_on: max(cm.inserted_at),
        is_new: false
      }
    )
    |> Repo.all()
    |> Enum.map(fn medal ->
      rarity_percentage = medal.contributors_have / contributor_count * 100.0

      medal
      |> Map.put(:rarity_percentage, rarity_percentage)
      |> Map.put(:rarity, Utils.get_rarity(rarity_percentage))
    end)
    |> Enum.sort_by(fn medal -> medal.rarity_percentage end)
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
