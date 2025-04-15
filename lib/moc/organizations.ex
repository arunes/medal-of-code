defmodule Moc.Organizations do
  import Moc.Utils.Date, only: [utc_now: 0]
  alias Moc.Repo
  alias Moc.Schema
  alias Moc.Sync.Connector

  # 6 months
  @cutoff_date utc_now() |> NaiveDateTime.add(6 * 30 * 24 * 60 * 60 * -1)

  def create_organization(params) do
    %Schema.Organization{}
    |> Schema.Organization.create_changeset(params)
    |> Repo.insert()
    |> create_projects()
  end

  def change_creation(%Schema.Organization{} = organization, attrs \\ %{}) do
    Schema.Organization.create_changeset(organization, attrs,
      validate_token: false,
      validate_id: false
    )
  end

  defp create_projects({:error, _} = result), do: result

  defp create_projects({:ok, organization} = result) do
    settings = %Connector{
      provider: organization.provider |> String.to_atom(),
      organization_id: organization.external_id,
      token: organization.token
    }

    Connector.get_projects(settings)
    |> Enum.map(fn prj ->
      Repo.insert!(%Schema.Project{
        organization_id: organization.id,
        external_id: prj.id,
        name: prj.name,
        description: prj.description,
        url: prj.url
      })
    end)
    |> Enum.each(&create_repositories(&1, settings))

    result
  end

  defp create_repositories(project, settings) do
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

    Repo.insert_all(Schema.Repository, repositories)
    {:ok}
  end
end
