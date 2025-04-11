defmodule Moc.Contributor do
  defstruct [:id, :name, :rank, :level, :title, :prefix, :number_of_medals]
end

defmodule Moc.Contributors do
  import Ecto.Query
  alias Moc.Settings
  alias Moc.Repo
  alias Moc.Schema

  def get_list() do
    query_all() |> Repo.all()
  end

  def get_contributor(id) when is_binary(id),
    do: id |> String.to_integer() |> get_contributor()

  def get_contributor(id) when is_integer(id) do
    query_get_contributor(id) |> Repo.all()
  end

  # Queries
  defp query_all do
    settings = Settings.get()

    from(cnt in Schema.ContributorOverview,
      select: %Moc.Contributor{
        id: cnt.id,
        name: cnt.name,
        rank: cnt.rank,
        level: cnt.level,
        title: cnt.title,
        prefix: cnt.prefix,
        number_of_medals: cnt.number_of_medals
      }
    )
    |> sort_contributors(settings.contributors.ranks)
  end

  def query_get_contributor(id) when is_integer(id) do
    query_all() |> where([cnt], cnt.id == ^id)
  end

  def query_get_contributor(id) when is_binary(id) do
    id |> String.to_integer() |> query_get_contributor()
  end

  defp sort_contributors(query, true), do: query |> order_by([c], asc: c.rank)
  defp sort_contributors(query, false), do: query |> order_by([c], asc: c.name)
end
