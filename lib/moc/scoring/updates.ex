defmodule Moc.Scoring.Updates do
  import Ecto.Query
  require Logger
  alias Moc.Scoring.Update
  alias Moc.Utils
  alias Moc.Repo
  alias Moc.Scoring.Type
  alias Moc.Contributors.ContributorOverview

  @spec save_updates(list(Type.medal_winner()), list(ContributorOverview)) :: :ok
  def save_updates(medal_winners, contributors_before) do
    Logger.info("Saving updates.")

    medal_winners
    |> get_medal_updates()
    |> get_other_updates(contributors_before)
    |> insert_updates

    :ok
  end

  defp get_medal_updates(medal_winners) do
    medal_winners
    |> Enum.map(fn w ->
      %{type: "medalWon", contributor_id: w.contributor_id, medal_id: w.medal_id}
    end)
  end

  defp get_other_updates(updates, contributors_before) do
    query_contributors()
    |> Repo.all()
    |> get_updates_for_contributor(updates, contributors_before)
    |> Enum.filter(&(&1 != :none))
  end

  defp get_updates_for_contributor([], updates, _contributors_before), do: updates

  defp get_updates_for_contributor([current | rest], updates, contributors_before) do
    existing = contributors_before |> Enum.find(&(&1.id == current.id))

    new_updates = [
      get_xp_update(existing, current),
      get_level_update(existing, current),
      get_title_update(existing, current),
      get_prefix_update(existing, current),
      get_charisma_update(existing, current),
      get_constitution_update(existing, current),
      get_dexterity_update(existing, current),
      get_wisdom_update(existing, current)
      | updates
    ]

    get_updates_for_contributor(rest, new_updates, contributors_before)
  end

  #### XP Updates
  defp get_xp_update(nil, current),
    do: %{type: "xpIncrease", contributor_id: current.id, xp: current.xp}

  defp get_xp_update(existing, current) when current.xp > existing.xp,
    do: %{type: "xpIncrease", contributor_id: current.id, xp: current.xp - existing.xp}

  defp get_xp_update(_, _), do: :none

  #### Level Updates
  defp get_level_update(nil, current),
    do: %{type: "levelUp", contributor_id: current.id, level: current.level}

  defp get_level_update(existing, current) when current.level > existing.level,
    do: %{type: "levelUp", contributor_id: current.id, level: current.level}

  defp get_level_update(_, _),
    do: :none

  #### Title Updates
  defp get_title_update(nil, current),
    do: %{type: "titleChange", contributor_id: current.id, title: current.title}

  defp get_title_update(existing, current) when current.title != existing.title,
    do: %{type: "titleChange", contributor_id: current.id, title: current.title}

  defp get_title_update(_, _),
    do: :none

  #### Prefix Updates
  defp get_prefix_update(nil, current),
    do: %{type: "prefixChange", contributor_id: current.id, prefix: current.prefix}

  defp get_prefix_update(existing, current) when current.prefix != existing.prefix,
    do: %{type: "prefixChange", contributor_id: current.id, prefix: current.prefix}

  defp get_prefix_update(_, _),
    do: :none

  #### Charisma Updates
  defp get_charisma_update(nil, current),
    do: %{type: "charismaIncrease", contributor_id: current.id, charisma: current.charisma}

  defp get_charisma_update(existing, current) when current.charisma > existing.charisma,
    do: %{
      type: "charismaIncrease",
      contributor_id: current.id,
      charisma: current.charisma - existing.charisma
    }

  defp get_charisma_update(_, _), do: :none

  #### Constitution Updates
  defp get_constitution_update(nil, current),
    do: %{
      type: "constitutionIncrease",
      contributor_id: current.id,
      constitution: current.constitution
    }

  defp get_constitution_update(existing, current)
       when current.constitution > existing.constitution,
       do: %{
         type: "constitutionIncrease",
         contributor_id: current.id,
         constitution: current.constitution - existing.constitution
       }

  defp get_constitution_update(_, _), do: :none

  #### Dexterity Updates
  defp get_dexterity_update(nil, current),
    do: %{type: "dexterityIncrease", contributor_id: current.id, dexterity: current.dexterity}

  defp get_dexterity_update(existing, current) when current.dexterity > existing.dexterity,
    do: %{
      type: "dexterityIncrease",
      contributor_id: current.id,
      dexterity: current.dexterity - existing.dexterity
    }

  defp get_dexterity_update(_, _), do: :none

  #### Wisdom Updates
  defp get_wisdom_update(nil, current),
    do: %{type: "wisdomIncrease", contributor_id: current.id, wisdom: current.wisdom}

  defp get_wisdom_update(existing, current) when current.wisdom > existing.wisdom,
    do: %{
      type: "wisdomIncrease",
      contributor_id: current.id,
      wisdom: current.wisdom - existing.wisdom
    }

  defp get_wisdom_update(_, _), do: :none

  # Insert Updates
  defp insert_updates([]), do: {:ok, 0}

  defp insert_updates(updates) do
    to_insert = updates |> Enum.map(&normalize_update/1)
    Repo.insert_all(Update, to_insert)
  end

  defp normalize_update(upd) do
    upd
    |> Map.put(:xp, Map.get(upd, :xp))
    |> Map.put(:level, Map.get(upd, :level))
    |> Map.put(:title, Map.get(upd, :title))
    |> Map.put(:prefix, Map.get(upd, :prefix))
    |> Map.put(:charisma, Map.get(upd, :charisma))
    |> Map.put(:constitution, Map.get(upd, :constitution))
    |> Map.put(:dexterity, Map.get(upd, :dexterity))
    |> Map.put(:wisdom, Map.get(upd, :wisdom))
    |> Map.put(:medal_id, Map.get(upd, :medal_id))
    |> Map.put(:inserted_at, Utils.utc_now())
    |> Map.put(:updated_at, Utils.utc_now())
  end

  # Queries
  defp query_contributors do
    from(cnt in ContributorOverview)
  end
end
