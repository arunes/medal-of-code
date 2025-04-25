defmodule Moc.Admin.OrganizationView do
  defstruct [
    :id,
    :provider,
    :external_id,
    :total_projects,
    :total_repos,
    :total_active_repos,
    :updated_at
  ]
end

defmodule Moc.Admin.ProjectView do
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

defmodule Moc.Admin.RepositoryView do
  defstruct [
    :id,
    :name,
    :url,
    :sync_enabled,
    :cutoff_date,
    :inserted_at
  ]
end

defmodule Moc.Admin do
  import Ecto.Query
  alias Moc.Admin.SyncHistory
  alias Moc.Utils
  alias Hex.API.Key.Organization
  alias Moc.Connector
  alias Moc.Repo
  alias Moc.Admin.Organization
  alias Moc.Admin.Project
  alias Moc.Admin.Repository
  alias Moc.Admin.OrganizationView
  alias Moc.Admin.ProjectView
  alias Moc.Admin.RepositoryView

  def get_sync_history_list() do
    SyncHistory |> order_by([sh], desc: sh.inserted_at) |> Repo.all()
  end

  def get_organization_list() do
    from(org in Organization,
      left_join: prj in assoc(org, :projects),
      left_join: rp in assoc(prj, :repositories),
      group_by: [org.id, org.provider, org.external_id, org.inserted_at],
      select: %OrganizationView{
        id: org.id,
        provider: org.provider,
        external_id: org.external_id,
        total_projects: count(fragment("DISTINCT ?", prj.id)),
        total_repos: count(fragment("DISTINCT ?", rp.id)),
        total_active_repos:
          count(fragment("DISTINCT(CASE ? WHEN 1 THEN ? ELSE NULL END)", rp.sync_enabled, rp.id)),
        updated_at: org.updated_at
      },
      order_by: org.external_id
    )
    |> Repo.all()
  end

  def get_project_list(organization_id) do
    from(prj in Project,
      where: prj.organization_id == ^organization_id,
      left_join: rp in assoc(prj, :repositories),
      group_by: [prj.id, prj.name, prj.description, prj.url, prj.inserted_at],
      select: %ProjectView{
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
    |> Repo.all()
  end

  def get_organization!(organization_id) do
    Repo.get!(Organization, organization_id)
  end

  def delete_organization!(organization_id) do
    Repo.get!(Organization, organization_id) |> Repo.delete!()
  end

  def get_project!(project_id) do
    Repo.get!(Project, project_id)
  end

  def get_repository_list(_organization_id, project_id) do
    from(rp in Repository,
      where: rp.project_id == ^project_id,
      select: %RepositoryView{
        id: rp.id,
        name: rp.name,
        url: rp.url,
        sync_enabled: rp.sync_enabled,
        cutoff_date: rp.cutoff_date,
        inserted_at: rp.inserted_at
      },
      order_by: rp.name
    )
    |> Repo.all()
  end

  def toggle_sync!(repository_id) do
    repo =
      from(rp in Repository, where: rp.id == ^repository_id)
      |> Repo.one!()

    repo
    |> Repository.create_changeset(%{sync_enabled: !repo.sync_enabled})
    |> Repo.update()

    !repo.sync_enabled
  end

  @doc """
  Creates a organization and syncs the projects
  """
  @spec create_organization(map()) :: {:ok | :error, Ecto.Changeset.t()}
  def create_organization(attrs) do
    %Organization{}
    |> Organization.create_changeset(attrs)
    |> Repo.insert()
    |> maybe_run_sync()
  end

  def change_create_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.create_changeset(organization, attrs,
      validate_token: false,
      validate_id: false
    )
  end

  defp maybe_run_sync({:ok, changeset}) do
    sync_projects(changeset)
  end

  defp maybe_run_sync(result), do: result

  def sync_projects(changeset) do
    settings = %Connector{
      provider: changeset.provider,
      organization_id: changeset.external_id,
      token: changeset.token
    }

    Connector.get_projects(settings)
    |> Enum.map(fn prj ->
      Repo.insert!(%Project{
        organization_id: changeset.id,
        external_id: prj.id,
        name: prj.name,
        description: prj.description,
        url: prj.url
      })
    end)
    |> Enum.each(fn prj ->
      repositories =
        Connector.get_repositories(settings, prj.external_id)
        |> Enum.map(fn repo ->
          %{
            project_id: prj.id,
            external_id: repo.id,
            name: repo.name,
            url: repo.url,
            sync_enabled: false,
            cutoff_date:
              DateTime.utc_now()
              |> DateTime.add(6 * 30 * 24 * 60 * 60 * -1)
              |> DateTime.truncate(:second),
            inserted_at: Utils.utc_now(),
            updated_at: Utils.utc_now()
          }
        end)

      Repo.insert_all(Repository, repositories)
    end)

    {:ok, changeset}
  end
end
