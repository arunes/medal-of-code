defmodule Moc.Contributors do
  import Ecto.Query
  alias Moc.Utils
  alias Moc.Instance
  alias Moc.Repo
  alias Moc.Contributors.ContributorOverview

  def get_contributor!(contributor_id) do
    Repo.get!(ContributorOverview, contributor_id)
  end

  def get_list(params) do
    show_rank = Instance.get_settings() |> Utils.get_setting_value("contributor.show_rank")

    from(ContributorOverview)
    |> order_contributor_list(show_rank)
    |> filter_contributor_list(params)
    |> Repo.all()
  end

  defp order_contributor_list(query, true), do: query |> order_by([c], c.rank)
  defp order_contributor_list(query, false), do: query |> order_by([c], c.name)

  defp filter_contributor_list(query, %{"search" => search}) do
    query |> where([c], c.name == "" or like(c.name, ^"%#{search}%"))
  end

  defp filter_contributor_list(query, _), do: query
end
