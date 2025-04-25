defmodule Moc.PullRequests.ImportResult do
  @type t :: %__MODULE__{
          number_of_prs: integer(),
          number_of_reviews: integer(),
          number_of_comments: integer()
        }

  defstruct(number_of_prs: 0, number_of_reviews: 0, number_of_comments: 0)
end

defmodule Moc.PullRequests do
  require Logger
  import Ecto.Query
  alias Moc.Admin.SyncHistory
  alias Moc.Contributors.ContributorCache
  alias Moc.Utils
  alias Moc.Connector
  alias Moc.PullRequests.ImportResult
  alias Moc.PullRequests.PullRequest
  alias Moc.PullRequests.PullRequestReview
  alias Moc.PullRequests.PullRequestComment
  alias Moc.Admin.Repository
  alias Moc.Repo

  @doc """
  Imports pull requests for enabled repositories and returs the number of pull requests imported
  """
  @spec do_import!() :: ImportResult.t()
  def do_import! do
    history = %SyncHistory{} |> SyncHistory.create_changeset() |> Repo.insert!()

    result =
      get_repos_to_sync()
      |> download_prs()
      |> insert_results_to_db()
      |> Enum.reduce(%ImportResult{}, fn r, acc ->
        %{
          acc
          | number_of_prs: acc.number_of_prs + r.number_of_prs,
            number_of_reviews: acc.number_of_reviews + r.number_of_reviews,
            number_of_comments: acc.number_of_comments + r.number_of_comments
        }
      end)

    # TODO: Hande failure
    history
    |> SyncHistory.update_changeset(%{
      prs_imported: result.number_of_prs,
      reviews_imported: result.number_of_reviews,
      comments_imported: result.number_of_comments,
      status: :finished
    })
    |> Repo.update!()

    result
  end

  defp insert_results_to_db(prs, result \\ [])
  defp insert_results_to_db([], result), do: result

  defp insert_results_to_db([{repo_id, prs} | rest], result) do
    {total_prs, _} = insert_prs_to_db(repo_id, prs)
    pr_id_map = get_pr_id_map(prs)
    {total_reviews, _} = insert_reviews_to_db(prs, pr_id_map)
    {total_comments, _} = insert_comments_to_db(prs, pr_id_map)

    current_total = %ImportResult{
      number_of_prs: total_prs,
      number_of_reviews: total_reviews,
      number_of_comments: total_comments
    }

    insert_results_to_db(rest, [current_total | result])
  end

  defp get_pr_id_map(prs) do
    # get newly inserted pr ids from db
    external_ids = prs |> Enum.map(& &1.id)

    from(pr in PullRequest,
      where: pr.external_id in ^external_ids,
      select: %{
        id: pr.id,
        external_id: pr.external_id
      }
    )
    |> Repo.all()
    |> Enum.reduce(%{}, fn %{external_id: external_id, id: id}, acc ->
      Map.put(acc, external_id, id)
    end)
  end

  defp insert_comments_to_db(prs, pr_id_map) do
    result =
      prs
      |> Enum.flat_map(fn pr ->
        pr.threads
        |> Enum.flat_map(fn th ->
          th.comments
          |> Enum.map(fn cmt ->
            cmt
            |> Map.put(:thread_id, th.id)
            |> Map.put(:thread_status, th.status)
            |> Map.put(:pull_request_id, pr.id)
          end)
        end)
      end)
      |> Enum.map(fn cmt ->
        %{
          external_id: cmt.id,
          thread_id: cmt.thread_id,
          thread_status: cmt.thread_status |> Utils.nullable_atom(),
          parent_comment_id: cmt.parent_comment_id,
          content: cmt.content || "",
          comment_type: cmt.comment_type |> String.to_atom(),
          published_on: cmt.published_on |> Utils.string_to_utc(),
          updated_on: cmt.updated_on |> Utils.string_to_utc(),
          created_by_id: ContributorCache.get_by_id(cmt.created_by),
          liked_by: cmt.users_liked |> Enum.map(&ContributorCache.get_by_id/1) |> Enum.join(","),
          pull_request_id: pr_id_map[cmt.pull_request_id],
          inserted_at: Utils.utc_now(),
          updated_at: Utils.utc_now()
        }
      end)
      |> then(&Repo.insert_all(PullRequestComment, &1))

    # update prs to set comment import date
    pr_ids = pr_id_map |> Enum.map(fn {_, v} -> v end)

    Repo.update_all(from(pr in PullRequest, where: pr.id in ^pr_ids),
      set: [comments_imported_on: Utils.utc_now()]
    )

    result
  end

  defp insert_reviews_to_db(prs, pr_id_map) do
    prs
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
            reviewer_id: ContributorCache.get_by_id(rw),
            pull_request_id: pr_id_map[pr.id],
            inserted_at: Utils.utc_now(),
            updated_at: Utils.utc_now()
          }
        end)

      reviewers ++ acc
    end)
    |> then(&Repo.insert_all(PullRequestReview, &1))
  end

  defp insert_prs_to_db(repo_id, prs) do
    prs
    |> Enum.map(fn pr ->
      %{
        external_id: pr.id,
        title: pr.title,
        description: pr.description,
        status: pr.status |> String.to_atom(),
        created_on: pr.created_on |> Utils.string_to_utc(),
        closed_on: pr.completed_on |> Utils.string_to_utc(),
        source_branch: pr.source_branch |> String.replace("refs/heads/", ""),
        target_branch: pr.target_branch |> String.replace("refs/heads/", ""),
        is_draft: pr.is_draft,
        created_by_id: ContributorCache.get_by_id(pr.created_by),
        delete_source_branch: pr.completionOptions.delete_source_branch,
        squash_merge: pr.completionOptions.squash_merge,
        merge_strategy: pr.completionOptions.merge_strategy |> Utils.nullable_atom(),
        ready_for_use: false,
        repository_id: repo_id,
        inserted_at: Utils.utc_now(),
        updated_at: Utils.utc_now()
      }
    end)
    |> then(&Repo.insert_all(PullRequest, &1))
  end

  defp download_prs(repos, result \\ [])
  defp download_prs([], result), do: result

  defp download_prs([repo | rest], result) do
    Logger.info("Getting pull requests for repo with id '#{repo.repo_external_id}'")

    settings = %Connector{
      provider: repo.org_provider,
      organization_id: repo.org_external_id,
      token: repo.org_token
    }

    completed_pr_cutoff_date =
      repo.last_completed_pr_date || repo.cutoff_date |> DateTime.add(1, :millisecond)

    abandoned_pr_cutoff_date =
      repo.last_abandoned_pr_date || repo.cutoff_date |> DateTime.add(1, :millisecond)

    Logger.info("Getting completed PRs completed after '#{completed_pr_cutoff_date}'.")

    completed_prs =
      Connector.get_pull_requests(
        settings,
        repo.repo_external_id,
        "completed",
        completed_pr_cutoff_date
      )

    Logger.info("Getting abandoned PRs abandoned after '#{abandoned_pr_cutoff_date}'.")

    abandoned_prs =
      Connector.get_pull_requests(
        settings,
        repo.repo_external_id,
        "abandoned",
        abandoned_pr_cutoff_date
      )

    Logger.info("Getting comments for PRs.")

    all_prs =
      (completed_prs ++ abandoned_prs)
      |> download_threads(repo.project_external_id, settings)

    download_prs(rest, [{repo.repo_id, all_prs} | result])
  end

  defp download_threads(prs, project_id, settings, result \\ [])
  defp download_threads([], _, _, result), do: result

  defp download_threads([pr | rest], project_id, settings, result) do
    threads =
      Connector.get_threads(
        settings,
        project_id,
        pr.repository_id,
        pr.id
      )

    download_threads(rest, project_id, settings, [%{pr | threads: threads} | result])
  end

  defp get_repos_to_sync do
    from(rp in Repository,
      where: rp.sync_enabled == true,
      join: prj in assoc(rp, :project),
      join: org in assoc(prj, :organization),
      left_join: pra in PullRequest,
      on: pra.repository_id == rp.id and pra.status == :abandoned,
      left_join: prc in PullRequest,
      on: prc.repository_id == rp.id and prc.status == :completed,
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
        project_external_id: prj.external_id,
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
