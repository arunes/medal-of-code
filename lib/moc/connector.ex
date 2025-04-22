defmodule Moc.Connector do
  @moduledoc """
  The `Moc.Connector` module provides a unified interface for interacting with various providers, 
  such as Azure, to fetch projects, repositories, pull requests, and threads, and validate tokens. 

  It defines the structure and expected types for settings and implements the logic for delegating 
  provider-specific operations to corresponding modules.
  """

  alias Moc.Connector.Azure
  alias Moc.Connector.Type

  @type t :: %__MODULE__{
          provider: Type.provider(),
          organization_id: String.t(),
          token: String.t()
        }
  defstruct [:provider, organization_id: "", token: ""]

  @doc """
  Validates the authentication token for the given provider settings.

  ## Parameters
    - `settings`: A struct containing provider-specific settings.

  ## Returns
    - `:ok` if the token is valid.
    - `:not_found` if the id is not found.
    - `:unauthorized` if the token is invalid.
  """
  @spec validate_token(t()) :: :ok | :not_found | :unauthorized
  def validate_token(%{provider: :azure} = settings) do
    Azure.validate_token(settings)
  end

  @doc """
  Fetches the list of projects for the given provider settings.

  ## Parameters
    - `settings`: A struct containing provider-specific settings.

  ## Returns
    - A list of projects (`Type.project()`).
  """
  @spec get_projects(t()) :: list(Type.project())
  def get_projects(%{provider: :azure} = settings) do
    Azure.get_projects(settings)
  end

  @doc """
  Fetches the list of repositories for a specified project ID.

  ## Parameters
    - `settings`: A struct containing provider-specific settings.
    - `project_id`: The ID of the project.

  ## Returns
    - A list of repositories (`Type.repository()`).
  """
  @spec get_repositories(t(), String.t()) :: list(Type.repository())
  def get_repositories(%{provider: :azure} = settings, project_id) do
    Azure.get_repositories(settings, project_id)
  end

  @doc """
  Fetches the list of pull requests for a specified repository ID, status, and minimum date.

  ## Parameters
    - `settings`: A struct containing provider-specific settings.
    - `repository_id`: The ID of the repository.
    - `status`: The status of the pull requests.
    - `min_date`: The minimum creation date for the pull requests.

  ## Returns
    - A list of pull requests (`Type.pull_request()`).
  """
  @spec get_pull_requests(t(), String.t(), String.t(), NaiveDateTime.t()) ::
          list(Type.pull_request())
  def get_pull_requests(%{provider: :azure} = settings, repository_id, status, min_date) do
    Azure.get_pull_requests(settings, repository_id, status, min_date, 0)
  end

  @doc """
  Fetches the list of threads for a specified project ID, repository ID, and pull request ID.

  ## Parameters
    - `settings`: A struct containing provider-specific settings.
    - `project_id`: The ID of the project.
    - `repository_id`: The ID of the repository.
    - `pull_request_id`: The ID of the pull request.

  ## Returns
    - A list of threads (`Type.thread()`).
  """
  @spec get_threads(t(), String.t(), String.t(), String.t()) :: list(Type.thread())
  def get_threads(%{provider: :azure} = settings, project_id, repository_id, pull_request_id) do
    Azure.get_threads(settings, project_id, repository_id, pull_request_id)
  end
end
