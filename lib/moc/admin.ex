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

defmodule Moc.Admin do
  import Ecto.Query
  alias Moc.Connector
  alias Moc.Repo
  alias Moc.Admin.Organization
  alias Moc.Admin.OrganizationView

  def get_organization_list() do
    from(org in Organization,
      # left_join: prj in assoc(org, :projects),
      # left_join: rp in assoc(prj, :repositories),
      group_by: [org.id, org.provider, org.external_id, org.inserted_at],
      select: %OrganizationView{
        id: org.id,
        provider: org.provider,
        external_id: org.external_id,
        # count(fragment("DISTINCT ?", prj.id)),
        total_projects: 0,
        # count(fragment("DISTINCT ?", rp.id)),
        total_repos: 0,
        total_active_repos: 0,
        # count(fragment("DISTINCT(CASE ? WHEN 1 THEN ? ELSE NULL END)", rp.sync_enabled, rp.id)),
        updated_at: org.updated_at
      },
      order_by: org.external_id
    )
    |> Repo.all()
  end

  @doc """
  Creates a organization and syncs the projects
  """
  @spec create_organization(map()) :: {:ok | :error, integer()}
  def create_organization(params) do
    %Organization{}
    |> Organization.create_changeset(params)
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
      Repo.insert!(%Moc.Admin.Project{
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
            inserted_at: DateTime.utc_now() |> DateTime.truncate(:second),
            updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
          }
        end)

      Repo.insert_all(Moc.Admin.Repository, repositories)
    end)

    {:ok, changeset}
  end
end
