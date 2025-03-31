defmodule Sync.Impl.External.Azure do
  import Sync.Impl.Utils, only: [format_utc_date: 1]
  alias Sync.Impl.External

  @page_size 25

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

  def get_pull_requests(
        %External{} = settings,
        repository_id,
        status,
        min_date,
        skip
      ) do
    # increase 1 second to not to get the already retrieved pr
    min_date = NaiveDateTime.add(min_date, 1)

    url =
      "https://dev.azure.com/#{settings.organization_id}/_apis/git/repositories/#{repository_id}/pullrequests?searchCriteria.queryTimeRangeType=closed&searchCriteria.minTime=#{format_utc_date(min_date)}&searchCriteria.status=#{status}&$skip=#{skip}&$top=#{@page_size}&api-version=7.1"

    case get_external_data(settings, url, fn res ->
           %{
             id: res["pullRequestId"],
             repository_id: res["repository"]["id"],
             title: res["title"],
             description: res["description"],
             status: res["status"],
             created_on: res["creationDate"],
             completed_on: res["closedDate"],
             source_branch: res["sourceRefName"],
             target_branch: res["targetRefName"],
             is_draft: res["isDraft"],
             created_by: %{
               id: res["createdBy"]["id"],
               name: res["createdBy"]["displayName"],
               email: res["createdBy"]["uniqueName"]
             },
             reviewers:
               res["reviewers"]
               |> Enum.map(fn rev ->
                 %{
                   id: rev["id"],
                   name: rev["displayName"],
                   email: rev["uniqueName"],
                   vote: rev["vote"],
                   is_required: rev["isRequired"]
                 }
               end),
             completionOptions: %{
               delete_source_branch: res["completionOptions"]["deleteSourceBranch"],
               squash_merge: res["completionOptions"]["squashMerge"],
               merge_strategy: res["completionOptions"]["mergeStrategy"]
             }
           }
         end) do
      [] ->
        []

      set ->
        set ++ get_pull_requests(settings, repository_id, status, min_date, skip + @page_size)
    end
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
