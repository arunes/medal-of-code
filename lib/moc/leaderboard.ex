defmodule Moc.Leaderboard do
  import Ecto.Query
  alias Moc.PullRequests.PullRequestReview
  alias Moc.PullRequests.PullRequestComment
  alias Moc.PullRequests.PullRequest
  alias Moc.Repo

  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          formatter: fun(),
          data: list(any())
        }

  defstruct [:id, :title, :formatter, :data]

  @spec get_list(DateTime.t()) :: list(t())
  def get_list(date) do
    boards = [
      %__MODULE__{
        id: 1,
        title: "Top PR Completers",
        formatter: fn count -> "#{count} prs." end,
        data: get_top_pr_completers(date.year, date.month)
      },
      %__MODULE__{
        id: 2,
        title: "Top Commenters",
        formatter: fn count -> "#{count} comments." end,
        data: get_top_commenters(date.year, date.month)
      },
      %__MODULE__{
        id: 3,
        title: "Top Commenters per PR",
        formatter: fn count -> "#{count} / pr." end,
        data: get_top_pr_completers(date.year, date.month)
      },
      %__MODULE__{
        id: 4,
        title: "Top Reviewers",
        formatter: fn count -> "#{count} votes." end,
        data: get_top_reviewers(date.year, date.month)
      },
      %__MODULE__{
        id: 5,
        title: "Highest Approval Rates",
        formatter: fn count -> "#{count}%." end,
        data: get_top_pr_completers(date.year, date.month)
      },
      %__MODULE__{
        id: 6,
        title: "Fastest PR Completers (on average)",
        formatter: fn count -> "#{count} / pr." end,
        data: get_top_pr_completers(date.year, date.month)
      }
    ]

    boards
  end

  defp get_top_pr_completers(year, month) do
    from(pr in PullRequest,
      where:
        pr.status == :completed and
          fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
          fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
            ^String.pad_leading(to_string(month), 2, "0"),
      join: c in assoc(pr, :created_by),
      group_by: [pr.created_by_id, c.name],
      select: %{
        id: pr.created_by_id,
        rank: over(row_number(), order_by: [desc: count(pr.id)]),
        name: c.name,
        count: count(pr.id)
      },
      order_by: [desc: count(pr.id)],
      limit: 5
    )
    |> Repo.all()
  end

  defp get_top_commenters(year, month) do
    from(prc in PullRequestComment,
      where:
        prc.comment_type == :text and
          fragment("STRFTIME ('%Y', ?)", prc.published_on) == ^to_string(year) and
          fragment("STRFTIME ('%m', ?)", prc.published_on) ==
            ^String.pad_leading(to_string(month), 2, "0"),
      join: c in assoc(prc, :created_by),
      group_by: [prc.created_by_id, c.name],
      select: %{
        id: prc.created_by_id,
        rank: over(row_number(), order_by: [desc: count(prc.id)]),
        name: c.name,
        count: count(prc.id)
      },
      order_by: [desc: count(prc.id)],
      limit: 5
    )
    |> Repo.all()
  end

  defp get_top_reviewers(year, month) do
    from(prr in PullRequestReview,
      join: c in assoc(prr, :reviewer),
      join: pr in assoc(prr, :pull_request),
      where:
        prr.vote != 0 and
          fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
          fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
            ^String.pad_leading(to_string(month), 2, "0"),
      group_by: [prr.reviewer_id, c.name],
      select: %{
        id: prr.reviewer_id,
        rank: over(row_number(), order_by: [desc: count(prr.id)]),
        name: c.name,
        count: count(prr.id)
      },
      order_by: [desc: count(prr.id)],
      limit: 5
    )
    |> Repo.all()
  end
end
