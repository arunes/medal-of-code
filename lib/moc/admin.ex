defmodule Moc.Repository do
  defstruct [
    :id,
    :name,
    :url,
    :sync_enabled,
    :cutoff_date,
    :inserted_at
  ]
end

defmodule Moc.Project do
  defstruct [
    :id,
    :name,
    :description,
    :url,
    :total_repos,
    :total_active_repos,
    :inserted_at
  ]
end

defmodule Moc.Organization do
  defstruct [
    :id,
    :provider,
    :external_id,
    :total_projects,
    :total_repos,
    :total_active_repos,
    :inserted_at
  ]
end

defmodule Moc.Admin do
  import Ecto.Query
  alias Moc.Organization
  alias Moc.Repository
  alias Moc.Project
  alias Moc.Repo
  alias Moc.Schema

  def get_organization_list() do
    query_organizations() |> Repo.all()
  end

  def get_project_list(id) when is_integer(id) do
    query_projects(id) |> Repo.all()
  end

  def get_project_list(id), do: id |> String.to_integer() |> get_project_list()

  def get_repository_list(id) when is_integer(id) do
    query_repositories(id) |> Repo.all()
  end

  def get_repository_list(id), do: id |> String.to_integer() |> get_repository_list()

  def toggle_sync(repository_id) when is_integer(repository_id) do
    repo =
      from(rp in Schema.Repository, where: rp.id == ^repository_id)
      |> Repo.one!()

    repo
    |> Schema.Repository.changeset(%{sync_enabled: !repo.sync_enabled})
    |> Repo.update()

    !repo.sync_enabled
  end

  def toggle_sync(repository_id), do: repository_id |> String.to_integer() |> toggle_sync()

  # Queries
  defp query_repositories(project_id) do
    from(rp in Schema.Repository,
      where: rp.project_id == ^project_id,
      select: %Repository{
        id: rp.id,
        name: rp.name,
        url: rp.url,
        sync_enabled: rp.sync_enabled,
        cutoff_date: rp.cutoff_date,
        inserted_at: rp.inserted_at
      },
      order_by: rp.name
    )
  end

  defp query_projects(organization_id) do
    from(prj in Schema.Project,
      where: prj.organization_id == ^organization_id,
      left_join: rp in assoc(prj, :repositories),
      group_by: [prj.id, prj.name, prj.description, prj.url, prj.inserted_at],
      select: %Project{
        id: prj.id,
        name: prj.name,
        description: prj.description,
        url: prj.url,
        total_repos: count(fragment("DISTINCT ?", rp.id)),
        total_active_repos:
          count(fragment("DISTINCT(CASE ? WHEN 1 THEN ? ELSE NULL END)", rp.sync_enabled, rp.id)),
        inserted_at: prj.inserted_at
      },
      order_by: prj.name
    )
  end

  defp query_organizations() do
    from(org in Schema.Organization,
      left_join: prj in assoc(org, :projects),
      left_join: rp in assoc(prj, :repositories),
      group_by: [org.id, org.provider, org.external_id, org.inserted_at],
      select: %Organization{
        id: org.id,
        provider: org.provider,
        external_id: org.external_id,
        total_projects: count(fragment("DISTINCT ?", prj.id)),
        total_repos: count(fragment("DISTINCT ?", rp.id)),
        total_active_repos:
          count(fragment("DISTINCT(CASE ? WHEN 1 THEN ? ELSE NULL END)", rp.sync_enabled, rp.id)),
        inserted_at: org.inserted_at
      },
      order_by: org.external_id
    )
  end
end
