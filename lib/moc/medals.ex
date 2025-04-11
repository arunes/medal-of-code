defmodule Moc.Medal do
  defstruct [
    :id,
    :name,
    :description,
    :lore,
    :affinity,
    :total_awarded,
    :rarity_percentage,
    :rarity,
    is_new: false
  ]
end

defmodule Moc.Medals do
  import Ecto.Query
  import Moc.Utils.Rarity, only: [get_rarity: 1]
  alias Moc.Contributor
  alias Moc.Contributors
  alias Moc.Schema
  alias Moc.Repo

  def get_list() do
    total_contributors = Moc.Repo.aggregate(Moc.Schema.Contributor, :count)

    query_all()
    |> Repo.all()
    |> Enum.map(&calculate_rarity(&1, total_contributors))
    |> Enum.sort_by(fn mdl -> mdl.rarity_percentage end)
  end

  def get_medal(id) do
    total_contributors = Moc.Repo.aggregate(Moc.Schema.Contributor, :count)
    query_get_medal(id) |> Repo.one!() |> calculate_rarity(total_contributors)
  end

  def get_winners(medal_id) do
    query_winners(medal_id) |> Repo.all()
  end

  defp calculate_rarity(%Moc.Medal{} = medal, total_contributors) do
    rarity_percentage = medal.total_awarded / total_contributors * 100.0
    %{medal | rarity_percentage: rarity_percentage, rarity: get_rarity(rarity_percentage)}
  end

  # queries
  defp query_winners(medal_id) do
    from(cm in Schema.ContributorMedal,
      where: cm.medal_id == ^medal_id,
      join: cnt in Schema.ContributorOverview,
      on: cnt.id == cm.contributor_id,
      group_by: [cnt.id, cnt.name, cnt.level, cnt.prefix, cnt.title, cnt.rank],
      select: %Contributor{
        id: cnt.id,
        name: cnt.name,
        level: cnt.level,
        prefix: cnt.prefix,
        title: cnt.title,
        rank: cnt.rank,
        number_of_medals: count(cm.id)
      }
    )
  end

  defp query_all() do
    from(md in Schema.Medal,
      left_join: cnt in assoc(md, :contributors),
      group_by: [md.id, md.name],
      select: %Moc.Medal{
        id: md.id,
        name: md.name,
        description: md.description,
        lore: md.lore,
        affinity: md.affinity,
        total_awarded: count(cnt.id)
      }
    )
  end

  defp query_get_medal(id) when is_integer(id) do
    query_all() |> where([md, cnt], md.id == ^id)
  end

  defp query_get_medal(id) when is_binary(id) do
    id |> String.to_integer() |> query_get_medal()
  end
end
