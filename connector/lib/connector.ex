defmodule Moc.Connector do
  alias Moc.Connector.Impl.Azure
  alias Moc.Connector.Type
  alias Ecto.Type

  @type t :: %__MODULE__{
          provider: Type.provider(),
          organization_id: String.t(),
          token: String.t()
        }
  defstruct [:provider, organization_id: "", token: ""]

  @spec get_projects(t()) :: list(Type.t_project())
  def get_projects(%{provider: :azure} = settings) do
    Azure.get_projects(settings)
  end

  @spec get_repositories(t(), String.t()) :: list(Type.t_repository())
  def get_repositories(%{provider: :azure} = settings, project_id) do
    Azure.get_repositories(settings, project_id)
  end

  @spec get_pull_requests(t(), String.t(), String.t(), DateTime.t()) ::
          list(Type.t_pull_request())
  def get_pull_requests(%{provider: :azure} = settings, repository_id, status, min_date) do
    Azure.get_pull_requests(settings, repository_id, status, min_date, 0)
  end
end
