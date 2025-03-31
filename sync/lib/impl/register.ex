defmodule Moc.Sync.Impl.Register do
  import Moc.Utils.Date, only: [utc_now: 0]
  alias Moc.Connector
  alias Moc.Db.Schema.Repository
  alias Moc.Db.Schema.Project
  alias Hex.API.Key.Organization
  alias Moc.Db.Schema.Organization
  alias Moc.Db.Repo
  import Ecto.Query

  # 6 months
  @cutoff_date utc_now() |> NaiveDateTime.add(6 * 30 * 24 * 60 * 60 * -1)

  @spec register(External.t()) :: {:ok} | {:error, String.t()}
  def register(%{organization_id: organization_id} = settings) do
    Repo.exists?(from(org in Organization, where: org.external_id == ^organization_id))
    |> create_organization(settings)

    {:ok}
  end

  defp create_organization(true = _exists, _settings), do: {:error, "organization already exists"}

  defp create_organization(_, settings) do
    %Organization{
      external_id: settings.organization_id,
      token: settings.token,
      provider: Atom.to_string(settings.provider)
    }
    |> Organization.changeset()
    |> Repo.insert()
    |> create_projects(settings)
  end

  defp create_projects({:error, _}, _settings), do: {:error, :schema}

  defp create_projects({:ok, organization}, settings) do
    Connector.get_projects(settings)
    |> Enum.map(fn prj ->
      Repo.insert(%Project{
        organization_id: organization.id,
        external_id: prj.id,
        name: prj.name,
        description: prj.description,
        url: prj.url
      })
    end)
    |> Enum.each(&create_repositories(&1, settings))

    {:ok, organization.id}
  end

  defp create_repositories({:error, _}, _settings), do: {:error, "an unknown db error occurred"}

  defp create_repositories({:ok, project}, settings) do
    repositories =
      Connector.get_repositories(settings, project.external_id)
      |> Enum.map(fn repo ->
        %{
          project_id: project.id,
          external_id: repo.id,
          name: repo.name,
          url: repo.url,
          sync_enabled: false,
          cutoff_date: @cutoff_date,
          inserted_at: utc_now(),
          updated_at: utc_now()
        }
      end)

    Repo.insert_all(Repository, repositories)
    {:ok}
  end
end
