defmodule Sync.Impl.External.Azure do
  alias Sync.Impl.External
  @spec get_projects(External.t_settings()) :: list(Sync.Impl.External.t_project())
  @doc """
  Gets a list of projects that belongs to the organization specified in settings.
  """
  def get_projects(%External{} = settings) do
    url = "https://dev.azure.com/#{settings.organization_id}/_apis/projects?api-version=7.1"

    get_external_data(settings, url, fn res ->
      %{id: res["id"], name: res["name"], description: res["description"], url: res["url"]}
    end)
  end

  @spec get_repositories(External.t_settings(), String.t()) ::
          list(Sync.Impl.External.t_repository())
  @doc """
  Gets the project's repositories.
  """
  def get_repositories(%External{} = settings, project_id) do
    url =
      "https://dev.azure.com/#{settings.organization_id}/#{project_id}/_apis/git/repositories?api-version=7.1"

    get_external_data(settings, url, fn res ->
      %{id: res["id"], name: res["name"], url: res["url"]}
    end)
  end

  # Helper functions

  defp get_external_data(settings, url, fun) do
    headers = get_headers(settings)

    url
    |> HTTPoison.get(headers)
    |> handle_api_response()
    |> Map.get("value", [])
    |> Enum.map(&fun.(&1))
  end

  defp get_headers(%External{token: token}) do
    [
      Authorization: "Basic #{Base.encode64(":#{token}")}",
      Accept: "Application/json; Charset=utf-8"
    ]
  end

  defp handle_api_response({:ok, %HTTPoison.Response{body: body}}),
    do: Jason.decode(body) |> handle_jason_response()

  defp handle_jason_response({:ok, map}), do: map
end
