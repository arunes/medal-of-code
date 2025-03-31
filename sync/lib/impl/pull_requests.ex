defmodule Moc.Sync.Impl.PullRequests do
  import Ecto.Query
  import Moc.Utils.Date, only: [new_utc: 0, string_to_utc: 1]
  require Logger
  alias Moc.Connector
  alias MocData.Schema
  alias MocData.Repo

  def sync do
    Logger.info("Getting repos to sync.")

    repos_to_sync = query_sync_request() |> Repo.all()
    total_repos = repos_to_sync |> Enum.count()
    Logger.info("#{total_repos} repos will be synced.")

    all_prs = repos_to_sync |> Enum.map(&get_prs/1) |> Enum.flat_map(& &1)
    contributor_ids = all_prs |> add_and_get_contributor_ids()

    repository_ids =
      repos_to_sync
      |> Enum.reduce(%{}, fn %{repo_external_id: external_id, repo_id: id}, acc ->
        Map.put(acc, external_id, id)
      end)

    all_prs |> add_pull_requests(repository_ids, contributor_ids)
    {:ok}
  end

  defp add_pull_requests(pull_requests, repository_ids, contributor_ids) do
    prs_to_insert =
      pull_requests
      |> Enum.map(fn pr ->
        %{
          external_id: pr.id,
          title: pr.title,
          description: pr.description,
          status: pr.status,
          created_on: pr.created_on |> string_to_utc,
          closed_on: pr.completed_on |> string_to_utc,
          source_branch: pr.source_branch |> String.replace("refs/heads", ""),
          target_branch: pr.target_branch |> String.replace("refs/heads", ""),
          is_draft: pr.is_draft,
          created_by_id: contributor_ids[pr.created_by.id],
          delete_source_branch: pr.completionOptions.delete_source_branch,
          squash_merge: pr.completionOptions.squash_merge,
          merge_strategy: pr.completionOptions.merge_strategy,
          ready_for_use: false,
          repository_id: repository_ids[pr.repository_id],
          inserted_at: new_utc(),
          updated_at: new_utc()
        }
      end)

    Repo.insert_all(Schema.PullRequest, prs_to_insert)

    inserted_pull_request_ids = pull_requests |> Enum.map(& &1.id)

    pull_request_ids =
      Repo.all(query_pr_id_by_external_ids(inserted_pull_request_ids))
      |> Enum.reduce(%{}, fn %{external_id: external_id, id: id}, acc ->
        Map.put(acc, external_id, id)
      end)

    reviewers_to_insert =
      pull_requests
      |> Enum.reduce([], fn pr, acc ->
        reviewers =
          pr.reviewers
          |> Enum.map(fn rw ->
            %{
              vote: rw.vote,
              is_required:
                case rw.is_required do
                  nil -> false
                  val -> val
                end,
              reviewer_id: contributor_ids[rw.id],
              pull_request_id: pull_request_ids[pr.id],
              inserted_at: new_utc(),
              updated_at: new_utc()
            }
          end)

        reviewers ++ acc
      end)

    Repo.insert_all(Schema.PullRequestReview, reviewers_to_insert)
  end

  defp add_and_get_contributor_ids(pull_requests) do
    Logger.info("Getting existing contributors.")
    all_contributors = Repo.all(query_contributor_ids())
    Logger.info("#{length(all_contributors)} existing contributors found.")
    all_contributor_external_ids = all_contributors |> Enum.map(& &1.external_id)
    Logger.info("Extracting contributors from pull request data (created by and reviewers).")

    new_contributors =
      pull_requests
      |> Enum.map(&[&1.created_by | &1.reviewers])
      |> Enum.flat_map(& &1)
      |> Enum.filter(&(not Enum.member?(all_contributor_external_ids, &1.id)))
      |> Enum.map(fn c ->
        %{
          external_id: c.id,
          name: c.name,
          email: c.email,
          active: true,
          inserted_at: new_utc(),
          updated_at: new_utc()
        }
      end)
      |> Enum.uniq_by(& &1.external_id)

    Logger.info("#{length(new_contributors)} new contributors found.")

    case length(new_contributors) do
      0 ->
        all_contributors

      _ ->
        Logger.info("Adding new contributors to db.")
        Repo.insert_all(Schema.Contributor, new_contributors)
        Repo.all(query_contributor_ids())
    end
    |> Enum.reduce(%{}, fn %{external_id: external_id, id: id}, acc ->
      Map.put(acc, external_id, id)
    end)
  end

  defp get_prs(repo) do
    Logger.info("Running pr sync for repo '#{repo.repo_external_id}'")
    IO.inspect(repo, label: "REPO")

    settings = %Connector{
      provider: repo.org_provider |> String.to_atom(),
      organization_id: repo.org_external_id,
      token: repo.org_token
    }

    completed_pr_cutoff_date = repo.last_completed_pr_date || repo.cutoff_date
    Logger.info("Getting completed PRs completed after '#{completed_pr_cutoff_date}'.")

    completed_prs =
      Connector.get_pull_requests(
        settings,
        repo.repo_external_id,
        "completed",
        completed_pr_cutoff_date
      )

    abandoned_pr_cutoff_date = repo.last_abandoned_pr_date || repo.cutoff_date
    Logger.info("Getting abandoned PRs abandoned after '#{abandoned_pr_cutoff_date}'.")

    abandoned_prs =
      Connector.get_pull_requests(
        settings,
        repo.repo_external_id,
        "abandoned",
        completed_pr_cutoff_date
      )

    all_prs = completed_prs ++ abandoned_prs
    Logger.info("#{length(all_prs)} new pull requests found.")
    all_prs
  end

  # Queries
  # Gets the list of repositories to sync
  defp query_sync_request do
    from(rp in Schema.Repository,
      where: rp.sync_enabled == true,
      join: prj in assoc(rp, :project),
      join: org in assoc(prj, :organization),
      left_join: pra in Schema.PullRequest,
      on: pra.repository_id == rp.id and pra.status == "abandoned",
      left_join: prc in Schema.PullRequest,
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
  end

  defp query_contributor_ids do
    from(c in Schema.Contributor,
      select: %{
        id: c.id,
        external_id: c.external_id
      }
    )
  end

  defp query_pr_id_by_external_ids(external_ids) do
    from(pr in Schema.PullRequest,
      where: pr.external_id in ^external_ids,
      select: %{
        id: pr.id,
        external_id: pr.external_id
      }
    )
  end
end
