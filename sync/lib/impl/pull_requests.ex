defmodule Sync.Impl.PullRequests do
  import Ecto.Query
  require Logger
  alias MocData.Schema.PullRequest
  alias MocData.Repo
  alias MocData.Schema.Repository

  def sync do
    Logger.info("Getting repos to sync.")

    repos_to_sync =
      query_sync_request()
      |> Repo.all()
      |> Enum.group_by(fn req -> {req.org_id, req.org_external_id, req.org_token} end)

    total_orgs = repos_to_sync |> Enum.count()
    total_repos = repos_to_sync |> Enum.sum_by(fn {_, v} -> length(v) end)
    Logger.info("#{total_orgs} org(s), #{total_repos} repos will be synced.")

    repos_to_sync
  end

  # Queries
  # Gets the list of repositories to sync
  defp query_sync_request do
    from(rp in Repository,
      where: rp.sync_enabled == true,
      join: prj in assoc(rp, :project),
      join: org in assoc(prj, :organization),
      left_join: pra in PullRequest,
      on: pra.repository_id == rp.id and pra.status == "abandoned",
      left_join: prc in PullRequest,
      on: prc.repository_id == rp.id and prc.status == "completed",
      group_by: [rp.cutoff_date, rp.id, rp.external_id, org.token, org.id, org.external_id],
      select: %{
        org_token: org.token,
        org_id: org.id,
        org_external_id: org.external_id,
        repo_id: rp.id,
        repo_external_id: rp.external_id,
        cutoff_date: rp.cutoff_date,
        last_abandoned_pr_date: max(pra.closed_on),
        last_completed_pr_date: max(prc.closed_on)
      }
    )
  end
end
