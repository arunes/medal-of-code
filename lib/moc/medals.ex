defmodule Moc.Medal do
  defstruct [
    :id,
    :name,
    :description,
    :lore,
    :affinity,
    :rarity_percentage,
    :rarity,
    :winners,
    total_awarded: 0,
    is_new: false
  ]
end

defmodule Moc.Medals do
  import Ecto.Query
  import Moc.Utils.Rarity, only: [get_rarity: 1]
  alias Moc.Contributor
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

  defp parse_winners(nil), do: []
  defp parse_winners(list), do: list |> String.split(",") |> Enum.map(&String.to_integer/1)

  defp calculate_rarity(%Moc.Medal{} = medal, 0),
    do: %{
      medal
      | total_awarded: 0,
        rarity_percentage: 0.0,
        rarity: get_rarity(0.0)
    }

  defp calculate_rarity(%Moc.Medal{} = medal, total_contributors) do
    winners = parse_winners(medal.winners)
    unique_winners = winners |> Enum.uniq() |> length()
    rarity_percentage = unique_winners / total_contributors * 100.0

    %{
      medal
      | total_awarded: length(winners),
        rarity_percentage: rarity_percentage,
        rarity: get_rarity(rarity_percentage)
    }
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
        number_of_medals: count(cm.id) |> selected_as(:count_medals)
      },
      order_by: [desc: selected_as(:count_medals)]
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
        winners: fragment("GROUP_CONCAT(?)", cnt.contributor_id)
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
