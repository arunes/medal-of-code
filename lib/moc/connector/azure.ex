defmodule Moc.Connector.Azure do
  alias Moc.Connector

  @page_size 500

  def validate_token(%Connector{} = settings) do
    url = "https://dev.azure.com/#{settings.organization_id}/_apis/connectiondata"

    headers = get_headers(settings)
    HTTPoison.get(url, headers) |> parse_validate_result()
  end

  defp parse_validate_result({:ok, %{status_code: 200, body: body}}) do
    case Jason.decode(body) |> IO.inspect() do
      {:ok, %{"authenticatedUser" => %{"id" => "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"}}} ->
        :unauthorized

      {:ok, _} ->
        :ok

      _ ->
        :not_found
    end
  end

  defp parse_validate_result({:ok, %{status_code: 302}}), do: :unauthorized
  defp parse_validate_result({:ok, %{status_code: 401}}), do: :unauthorized
  defp parse_validate_result({:ok, %{status_code: 404}}), do: :not_found

  def get_projects(%Connector{} = settings) do
    url = "https://dev.azure.com/#{settings.organization_id}/_apis/projects?api-version=7.1"

    get_external_data(settings, url, fn res ->
      %{id: res["id"], name: res["name"], description: res["description"], url: res["url"]}
    end)
  end

  def get_repositories(%Connector{} = settings, project_id) do
    url =
      "https://dev.azure.com/#{settings.organization_id}/#{project_id}/_apis/git/repositories?api-version=7.1"

    get_external_data(settings, url, fn res ->
      %{id: res["id"], name: res["name"], url: res["url"]}
    end)
  end

  def get_pull_requests(
        %Connector{} = settings,
        repository_id,
        status,
        min_date,
        skip
      ) do
    # increase 1 second to not to get the already retrieved pr
    min_date = DateTime.add(min_date, 1)

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
             threads: [],
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

  def get_threads(settings, project_id, repository_id, pull_request_id) do
    url =
      "https://dev.azure.com/#{settings.organization_id}/#{project_id}/_apis/git/repositories/#{repository_id}/pullRequests/#{pull_request_id}/threads?api-version=7.1"

    get_external_data(settings, url, fn res ->
      %{
        id: res["id"],
        status: res["status"],
        comments:
          res["comments"]
          |> Enum.map(fn cmt ->
            %{
              id: cmt["id"],
              parent_comment_id: cmt["parentCommentId"],
              content: cmt["content"],
              comment_type: cmt["commentType"],
              published_on: cmt["publishedDate"],
              updated_on: cmt["lastUpdatedDate"],
              created_by: %{
                id: cmt["author"]["id"],
                name: cmt["author"]["displayName"],
                email: cmt["author"]["uniqueName"]
              },
              users_liked:
                cmt["usersLiked"]
                |> Enum.map(fn usr ->
                  %{
                    id: usr["id"],
                    name: usr["displayName"],
                    email: usr["uniqueName"]
                  }
                end)
            }
          end)
      }
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

  defp get_headers(%Connector{token: token}) do
    [
      Authorization: "Basic #{Base.encode64(":#{token}")}",
      Accept: "Application/json; Charset=utf-8"
    ]
  end

  defp handle_api_response({:ok, %HTTPoison.Response{body: body}}),
    do: Jason.decode(body) |> handle_jason_response()

  defp handle_jason_response({:ok, map}), do: map

  defp format_utc_date(date, format \\ "%Y-%m-%dT%H:%M:%SZ"), do: Calendar.strftime(date, format)
end
