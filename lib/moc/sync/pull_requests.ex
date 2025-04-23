defmodule Moc.Sync.PullRequests do
  require Logger
  import Ecto.Query
  alias Moc.Sync.PullRequests
  alias Moc.Admin.Repository
  alias Moc.Repo

  @doc """
  Imports pull requests for enabled repositories and returs the number of pull requests imported
  """
  @spec do_import() :: {:ok | :error, integer()}
  def do_import do
    get_repos_to_sync() |> IO.inspect()

    {:ok, 3}
  end

  defp get_repos_to_sync do
    from(rp in Repository,
      where: rp.sync_enabled == true,
      join: prj in assoc(rp, :project),
      join: org in assoc(prj, :organization),
      left_join: pra in PullRequests,
      on: pra.repository_id == rp.id and pra.status == "abandoned",
      left_join: prc in PullRequest,
      on: prc.repository_id == rp.id and prc.status == "completed",
      group_by: [
        rp.cutoff_date,
        rp.id,
        rp.external_id,
        org.token,
        org.id,
        org.external_id,
        org.provider
      ],
      select: %{
        org_token: org.token,
        org_id: org.id,
        org_external_id: org.external_id,
        org_provider: org.provider,
        repo_id: rp.id,
        repo_external_id: rp.external_id,
        cutoff_date: rp.cutoff_date,
        last_abandoned_pr_date: max(pra.closed_on),
        last_completed_pr_date: max(prc.closed_on)
      }
    )
    |> Repo.all()
  end
end
