defmodule Moc.Sync.Impl.Comments do
  require Logger
  import Ecto.Query
  import Moc.Utils.Date, only: [utc_now: 0, string_to_utc: 1]

  alias Moc.Db.Runtime.ContributorCache
  alias Moc.Connector
  alias Moc.Db.Schema
  alias Moc.Db.Repo

  def sync do
    Logger.info("Getting repos to sync.")

    prs_to_sync = query_sync_request() |> Repo.all()
    total_repos = prs_to_sync |> Enum.count()
    Logger.info("#{total_repos} pull requests will be synced for comments.")

    prs_to_sync |> Enum.map(&get_comments/1)
  end

  defp get_comments(pull_request) do
    settings = %Connector{
      provider: pull_request.org_provider |> String.to_atom(),
      organization_id: pull_request.org_external_id,
      token: pull_request.org_token
    }

    comments_to_insert =
      Connector.get_threads(
        settings,
        pull_request.project_external_id,
        pull_request.repo_external_id,
        pull_request.pr_external_id
      )
      |> Enum.flat_map(fn th ->
        th.comments
        |> Enum.map(fn cmt ->
          cmt
          |> Map.put(:thread_id, th.id)
          |> Map.put(:thread_status, th.status)
        end)
      end)
      |> Enum.map(fn cmt ->
        %{
          external_id: cmt.id,
          thread_id: cmt.thread_id,
          thread_status: cmt.thread_status,
          parent_comment_id: cmt.parent_comment_id,
          content: cmt.content,
          comment_type: cmt.comment_type,
          published_on: cmt.published_on |> string_to_utc,
          updated_on: cmt.updated_on |> string_to_utc,
          created_by_id: ContributorCache.get_by_id(cmt.created_by),
          liked_by: cmt.users_liked |> Enum.map(&ContributorCache.get_by_id/1) |> Enum.join(","),
          pull_request_id: pull_request.pr_id,
          inserted_at: utc_now(),
          updated_at: utc_now()
        }
      end)

    Repo.insert_all(Schema.PullRequestComment, comments_to_insert)

    Ecto.Changeset.change(%Moc.Db.Schema.PullRequest{id: pull_request.pr_id}, %{
      comments_imported_on: utc_now()
    })
    |> Repo.update()
  end

  # Queries
  # Gets the list of repositories to sync
  defp query_sync_request do
    from(rp in Schema.Repository,
      join: prj in assoc(rp, :project),
      join: org in assoc(prj, :organization),
      join: pr in Schema.PullRequest,
      on: pr.repository_id == rp.id,
      where: rp.sync_enabled == true,
      where: is_nil(pr.comments_imported_on),
      select: %{
        org_token: org.token,
        org_external_id: org.external_id,
        org_provider: org.provider,
        project_external_id: prj.external_id,
        repo_external_id: rp.external_id,
        pr_id: pr.id,
        pr_external_id: pr.external_id
      }
    )
  end
end
