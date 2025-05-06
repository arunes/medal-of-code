defmodule Moc.Scoring.Updates do
  import Ecto.Query
  require Logger
  alias Moc.Scoring.Update
  alias Moc.Utils
  alias Moc.Repo
  alias Moc.Scoring.Type
  alias Moc.Contributors.ContributorOverview

  def get_update_list(%{contributor_id: nil, current_contributor_id: nil} = search_params),
    do: get_update_list_query(search_params) |> Repo.all()

  def get_update_list(
        %{contributor_id: nil, current_contributor_id: current_contributor_id} = search_params
      ),
      do:
        get_update_list_query(search_params)
        |> where([u, c, m], u.contributor_id == ^current_contributor_id)
        |> Repo.all()

  def get_update_list(search_params) do
    get_update_list_query(search_params)
    |> where([u, c, m], u.contributor_id == ^search_params.contributor_id)
    |> Repo.all()
  end

  defp maybe_add_level_filter(filters, false), do: filters
  defp maybe_add_level_filter(filters, true), do: [:xp_increase, :level_up | filters]
  defp maybe_add_affinity_filter(filters, false), do: filters
  defp maybe_add_affinity_filter(filters, true), do: [:prefix_change | filters]
  defp maybe_add_attribute_filter(filters, false), do: filters

  defp maybe_add_attribute_filter(filters, true),
    do: [
      :dexterity_increase,
      :charisma_increase,
      :wisdom_increase,
      :constitution_increase | filters
    ]

  defp get_update_list_query(search_params) do
    search_types =
      [:medal_won, :title_change]
      |> maybe_add_level_filter(search_params.show_level)
      |> maybe_add_affinity_filter(search_params.show_affinity)
      |> maybe_add_attribute_filter(search_params.show_attributes)

    from(upd in Update,
      join: cnt in assoc(upd, :contributor),
      left_join: md in assoc(upd, :medal),
      where: upd.type in ^search_types,
      select: %{
        contributor_id: upd.contributor_id,
        contributor_name: cnt.name,
        xp: upd.xp,
        type: upd.type,
        level: upd.level,
        title: upd.title,
        prefix: upd.prefix,
        dexterity: upd.dexterity,
        charisma: upd.charisma,
        wisdom: upd.wisdom,
        constitution: upd.constitution,
        medal_id: upd.medal_id,
        medal_name: md.name,
        inserted_at: upd.inserted_at
      },
      limit: ^search_params.number_of_records,
      order_by: [desc: upd.inserted_at]
    )
  end

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
      %{type: :medal_won, contributor_id: w.contributor_id, medal_id: w.medal_id}
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
    do: %{type: :xp_increase, contributor_id: current.id, xp: current.xp}

  defp get_xp_update(existing, current) when current.xp > existing.xp,
    do: %{type: :xp_increase, contributor_id: current.id, xp: current.xp - existing.xp}

  defp get_xp_update(_, _), do: :none

  #### Level Updates
  defp get_level_update(nil, current),
    do: %{type: :level_up, contributor_id: current.id, level: current.level}

  defp get_level_update(existing, current) when current.level > existing.level,
    do: %{type: :level_up, contributor_id: current.id, level: current.level}

  defp get_level_update(_, _),
    do: :none

  #### Title Updates
  defp get_title_update(nil, current),
    do: %{type: :title_change, contributor_id: current.id, title: current.title}

  defp get_title_update(existing, current) when current.title != existing.title,
    do: %{type: :title_change, contributor_id: current.id, title: current.title}

  defp get_title_update(_, _),
    do: :none

  #### Prefix Updates
  defp get_prefix_update(nil, current),
    do: %{type: :prefix_change, contributor_id: current.id, prefix: current.prefix}

  defp get_prefix_update(existing, current) when current.prefix != existing.prefix,
    do: %{type: :prefix_change, contributor_id: current.id, prefix: current.prefix}

  defp get_prefix_update(_, _),
    do: :none

  #### Charisma Updates
  defp get_charisma_update(nil, current),
    do: %{type: :charisma_increase, contributor_id: current.id, charisma: current.charisma}

  defp get_charisma_update(existing, current) when current.charisma > existing.charisma,
    do: %{
      type: :charisma_increase,
      contributor_id: current.id,
      charisma: current.charisma - existing.charisma
    }

  defp get_charisma_update(_, _), do: :none

  #### Constitution Updates
  defp get_constitution_update(nil, current),
    do: %{
      type: :constitution_increase,
      contributor_id: current.id,
      constitution: current.constitution
    }

  defp get_constitution_update(existing, current)
       when current.constitution > existing.constitution,
       do: %{
         type: :constitution_increase,
         contributor_id: current.id,
         constitution: current.constitution - existing.constitution
       }

  defp get_constitution_update(_, _), do: :none

  #### Dexterity Updates
  defp get_dexterity_update(nil, current),
    do: %{type: :dexterity_increase, contributor_id: current.id, dexterity: current.dexterity}

  defp get_dexterity_update(existing, current) when current.dexterity > existing.dexterity,
    do: %{
      type: :dexterity_increase,
      contributor_id: current.id,
      dexterity: current.dexterity - existing.dexterity
    }

  defp get_dexterity_update(_, _), do: :none

  #### Wisdom Updates
  defp get_wisdom_update(nil, current),
    do: %{type: :wisdom_increase, contributor_id: current.id, wisdom: current.wisdom}

  defp get_wisdom_update(existing, current) when current.wisdom > existing.wisdom,
    do: %{
      type: :wisdom_increase,
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
