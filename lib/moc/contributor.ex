defmodule Moc.Contributor do
  import Ecto.Query
  alias Moc.Settings
  alias Moc.Repo
  alias Moc.Schema.ContributorOverview

  def get_list() do
    query_get_contributors() |> Repo.all()
  end

  def get_contributor(id) when is_binary(id),
    do: id |> String.to_integer() |> get_contributor()

  def get_contributor(id) when is_integer(id) do
    query_get_contributor(id) |> Repo.all()
  end

  # Queries
  defp query_get_contributor(id) do
    from(cnt in ContributorOverview,
      where: cnt.id == ^id,
      select: %{
        id: cnt.id,
        name: cnt.name,
        rank: cnt.rank,
        level: cnt.level,
        title: cnt.title,
        prefix: cnt.prefix,
        number_of_medals: cnt.number_of_medals
      }
    )
  end

  defp query_get_contributors do
    settings = Settings.get()

    from(cnt in ContributorOverview,
      select: %{
        id: cnt.id,
        name: cnt.name,
        rank: cnt.rank,
        level: cnt.level,
        title: cnt.title,
        prefix: cnt.prefix,
        number_of_medals: cnt.number_of_medals
      }
    )
    |> sort_contributors(settings.contributors.ranks |> IO.inspect())
  end

  defp sort_contributors(query, true), do: query |> order_by([c], asc: c.rank)
  defp sort_contributors(query, false), do: query |> order_by([c], asc: c.name)
end
