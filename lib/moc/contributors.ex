defmodule Moc.Contributors do
  import Ecto.Query
  alias Moc.PullRequests.PullRequestReview
  alias Moc.PullRequests.PullRequestComment
  alias Moc.PullRequests.PullRequest
  alias Moc.Utils
  alias Moc.Instance
  alias Moc.Repo
  alias Moc.Contributors.ContributorOverview
  alias Moc.Contributors.ContributorActivity

  def get_contributor!(contributor_id) do
    Repo.get!(ContributorOverview, contributor_id)
  end

  def get_activities(contributor_id) do
    from(act in ContributorActivity,
      group_by: [act.date],
      where: act.contributor_id == ^contributor_id,
      select: %{
        date: act.date,
        count: count(act.date)
      }
    )
    |> Repo.all()
  end

  def get_contributor_stats!(contributor_id) do
    data =
      from(pr in PullRequest,
        where: pr.created_by_id == ^contributor_id,
        select: %{
          total_prs: count(pr.id),
          first_pr_date: min(pr.created_on),
          last_pr_date: max(pr.created_on),
          avg_completion:
            coalesce(
              avg(fragment("julianday(?) - julianday(?)", pr.closed_on, pr.created_on)),
              0.0
            ),
          total_time:
            coalesce(
              sum(fragment("julianday(?) - julianday(?)", pr.closed_on, pr.created_on)),
              0.0
            ),
          total_comments:
            subquery(
              from(prc in PullRequestComment,
                where: prc.created_by_id == ^contributor_id,
                select: count()
              )
            ),
          total_votes:
            subquery(
              from(prr in PullRequestReview,
                where: prr.reviewer_id == ^contributor_id and prr.vote != 0,
                select: count()
              )
            )
        }
      )
      |> Repo.one!()

    data
    |> Map.put(
      :pr_per_day,
      calculate_pr_per_day(data.total_prs, data.first_pr_date, data.last_pr_date)
    )
  end

  def get_contributor_list(params) do
    show_rank = Instance.get_settings() |> Utils.get_setting_value("contributor.show_rank")

    from(ContributorOverview)
    |> order_contributor_list(show_rank)
    |> filter_contributor_list(params)
    |> Repo.all()
  end

  defp order_contributor_list(query, true), do: query |> order_by([c], c.rank)
  defp order_contributor_list(query, false), do: query |> order_by([c], c.name)

  defp filter_contributor_list(query, %{"search" => search}) do
    query |> where([c], c.name == "" or like(c.name, ^"%#{search}%"))
  end

  defp filter_contributor_list(query, _), do: query

  defp calculate_pr_per_day(_, nil, nil), do: 0.0

  defp calculate_pr_per_day(total_prs, first_date, last_date),
    do: total_prs / Timex.diff(last_date, first_date, :days)
end
