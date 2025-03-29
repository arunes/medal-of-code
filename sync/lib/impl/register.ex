defmodule Sync.Impl.Register do
  alias MocData.Schema.Repository
  alias MocData.Schema.Project
  alias Sync.Impl.External
  alias Hex.API.Key.Organization
  alias Hex.API.Key.Organization
  alias MocData.Schema.Organization
  alias MocData.Repo
  import Ecto.Query

  # 6 months
  @cutoff_date DateTime.utc_now()
               |> DateTime.add(6 * 30 * 24 * 60 * 60 * -1)
               |> DateTime.truncate(:second)

  @spec register(External.t_settings()) :: {:ok} | {:error, String.t()}
  def register(%{organization_id: organization_id} = settings) do
    Repo.exists?(from(org in Organization, where: org.external_id == ^organization_id))
    |> create_organization(settings)

    {:ok}
  end

  defp create_organization(true = _exists, _settings), do: {:error, :exists}

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
    External.get_projects(settings)
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

  defp create_repositories({:error, _}, _settings), do: {:error, :schema}

  defp create_repositories({:ok, project}, settings) do
    repositories =
      External.get_repositories(settings, project.external_id)
      |> Enum.map(fn repo ->
        %{
          project_id: project.id,
          external_id: repo.id,
          name: repo.name,
          url: repo.url,
          sync_enabled: false,
          cutoff_date: @cutoff_date,
          inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
          updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        }
      end)

    Repo.insert_all(Repository, repositories)
  end
end
