defmodule Sync.Impl.External do
  alias Ecto.Type
  alias Sync.Type
  alias Sync.Impl.External.Azure
  @type t_project :: %{id: String.t(), name: String.t(), description: String.t(), url: String.t()}
  @type t_repository :: %{id: String.t(), name: String.t(), url: String.t()}

  @type t_settings :: %__MODULE__{
          provider: Type.provider(),
          organization_id: String.t(),
          token: String.t()
        }
  defstruct [:provider, organization_id: "", token: ""]

  @spec get_projects(t_settings()) :: list(t_project())
  def get_projects(%{provider: :azure} = settings) do
    Azure.get_projects(settings)
  end

  @spec get_repositories(t_settings(), String.t()) :: list(t_repository())
  def get_repositories(%{provider: :azure} = settings, project_id) do
    Azure.get_repositories(settings, project_id)
  end
end
