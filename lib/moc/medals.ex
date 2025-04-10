defmodule Moc.Medal do
  defstruct [:id, :name, :description, :affinity, :total_awarded, :rarity_percantage, :rarity]
end

defmodule Moc.Medals do
  import Ecto.Query
  import Moc.Utils.Rarity, only: [get_rarity: 1]
  alias Moc.Schema
  alias Moc.Repo

  def get_list() do
    total_contributors = Moc.Repo.aggregate(Moc.Schema.Contributor, :count)
    query_all() |> Repo.all() |> Enum.map(&calculate_rarity(&1, total_contributors))
  end

  def get_medal(id) do
    total_contributors = Moc.Repo.aggregate(Moc.Schema.Contributor, :count)
    query_get_medal(id) |> Repo.one!() |> calculate_rarity(total_contributors)
  end

  defp calculate_rarity(%Moc.Medal{} = medal, total_contributors) do
    rarity_percantage = medal.total_awarded / total_contributors * 100.0
    %{medal | rarity_percantage: rarity_percantage, rarity: get_rarity(rarity_percantage)}
  end

  # queries
  defp query_all() do
    from(md in Schema.Medal,
      left_join: cnt in assoc(md, :contributors),
      group_by: [md.id, md.name],
      select: %Moc.Medal{
        id: md.id,
        name: md.name,
        description: md.description,
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
