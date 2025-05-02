defmodule Moc.Leaderboard do
  import Ecto.Query
  alias Moc.Utils
  alias Moc.Instance
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

  @spec get_list(map()) :: list(t())
  def get_list(%{"date" => date}) do
    {:ok, formatted_date} = Date.from_iso8601(date)
    year = formatted_date.year
    month = formatted_date.month

    show_negative_lists =
      Instance.get_settings() |> Utils.get_setting_value("leaderboard.show_negative")

    boards = [
      %__MODULE__{
        id: 1,
        title: "Top PR Completers",
        formatter: fn count -> "#{count} prs." end,
        data: get_top_pr_completers(year, month)
      },
      %__MODULE__{
        id: 2,
        title: "Top Commenters",
        formatter: fn count -> "#{count} comments." end,
        data: get_top_commenters(year, month)
      },
      %__MODULE__{
        id: 3,
        title: "Top Commenters per PR",
        formatter: fn count -> "#{Float.round(count, 2)} / pr." end,
        data: get_top_commenters_per_pr(year, month)
      },
      %__MODULE__{
        id: 4,
        title: "Top Reviewers",
        formatter: fn count -> "#{count} votes." end,
        data: get_top_reviewers(year, month)
      },
      %__MODULE__{
        id: 5,
        title: "Highest Approval Rates",
        formatter: fn count -> "#{(count * 100.0) |> Float.round(2)}%." end,
        data: get_highest_approval_rates(year, month)
      },
      %__MODULE__{
        id: 6,
        title: "Fastest PR Completers (on average)",
        formatter: fn count -> Utils.get_duration(count) end,
        data: get_fastest_pr_completers(year, month)
      }
    ]

    (boards ++ get_negative_boards(show_negative_lists, year, month))
    |> add_rank
  end

  defp get_negative_boards(false, _, _), do: []

  defp get_negative_boards(true, year, month) do
    [
      %__MODULE__{
        id: 7,
        title: "Shortest Lived PR Creators",
        formatter: fn count -> Utils.get_duration(count) end,
        data: get_shortest_lived_pr_creators(year, month)
      },
      %__MODULE__{
        id: 8,
        title: "Longest Lived PR Creators",
        formatter: fn count -> Utils.get_duration(count) end,
        data: get_longest_lived_pr_creators(year, month)
      }
    ]
  end

  defp add_rank(boards) do
    boards
    |> Enum.map(fn brd ->
      %{
        brd
        | data:
            brd.data
            |> Enum.with_index()
            |> Enum.map(fn {d, idx} -> d |> Map.put(:rank, idx + 1) end)
      }
    end)
  end

  defp get_top_pr_completers(year, month) do
    from(pr in PullRequest,
      where:
        pr.status == :completed and
          (^year == 1 or
             (fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
                fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
                  ^String.pad_leading(to_string(month), 2, "0"))),
      join: c in assoc(pr, :created_by),
      group_by: [pr.created_by_id, c.name],
      select: %{
        id: pr.created_by_id,
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
          (^year == 1 or
             (fragment("STRFTIME ('%Y', ?)", prc.published_on) == ^to_string(year) and
                fragment("STRFTIME ('%m', ?)", prc.published_on) ==
                  ^String.pad_leading(to_string(month), 2, "0"))),
      join: c in assoc(prc, :created_by),
      group_by: [prc.created_by_id, c.name],
      select: %{
        id: prc.created_by_id,
        name: c.name,
        count: count(prc.id)
      },
      order_by: [desc: count(prc.id)],
      limit: 5
    )
    |> Repo.all()
  end

  defp get_top_commenters_per_pr(year, month) do
    from(prr in PullRequestReview,
      join: c in assoc(prr, :reviewer),
      join: pr in assoc(prr, :pull_request),
      left_join: prc in assoc(pr, :comments),
      where:
        ^year == 1 or
          (fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
             fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
               ^String.pad_leading(to_string(month), 2, "0")),
      group_by: [prr.reviewer_id, c.name],
      select: %{
        id: prr.reviewer_id,
        name: c.name,
        count:
          count(fragment("DISTINCT ?", prc.id)) * 1.0 /
            count(fragment("DISTINCT ?", prc.pull_request_id))
      },
      having: count(fragment("DISTINCT ?", prc.pull_request_id)) > 5,
      order_by: [
        desc:
          count(fragment("DISTINCT ?", prc.id)) * 1.0 /
            count(fragment("DISTINCT ?", prc.pull_request_id))
      ],
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
          (^year == 1 or
             (fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
                fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
                  ^String.pad_leading(to_string(month), 2, "0"))),
      group_by: [prr.reviewer_id, c.name],
      select: %{
        id: prr.reviewer_id,
        name: c.name,
        count: count(prr.id)
      },
      order_by: [desc: count(prr.id)],
      limit: 5
    )
    |> Repo.all()
  end

  defp get_highest_approval_rates(year, month) do
    from(prr in PullRequestReview,
      join: c in assoc(prr, :reviewer),
      join: pr in assoc(prr, :pull_request),
      where:
        ^year == 1 or
          (fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
             fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
               ^String.pad_leading(to_string(month), 2, "0")),
      group_by: [prr.reviewer_id, c.name],
      select: %{
        id: prr.reviewer_id,
        name: c.name,
        count:
          sum(fragment("(CASE WHEN ? in (5, 10) THEN 1 ELSE 0 END)", prr.vote)) * 1.0 /
            count(prr.id)
      },
      having: count(prr.id) > 5,
      order_by: [
        desc:
          sum(fragment("(CASE WHEN ? in (5, 10) THEN 1 ELSE 0 END)", prr.vote)) * 1.0 /
            count(prr.id)
      ],
      limit: 5
    )
    |> Repo.all()
  end

  defp get_fastest_pr_completers(year, month) do
    from(pr in PullRequest,
      where:
        pr.status == :completed and
          (^year == 1 or
             (fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
                fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
                  ^String.pad_leading(to_string(month), 2, "0"))),
      join: c in assoc(pr, :created_by),
      group_by: [pr.created_by_id, c.name],
      select: %{
        id: pr.created_by_id,
        name: c.name,
        count: avg(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on))
      },
      having: count(pr.id) > 2,
      order_by: avg(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on)),
      limit: 5
    )
    |> Repo.all()
  end

  defp get_shortest_lived_pr_creators(year, month) do
    from(pr in PullRequest,
      where:
        pr.status == :completed and
          (^year == 1 or
             (fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
                fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
                  ^String.pad_leading(to_string(month), 2, "0"))),
      join: c in assoc(pr, :created_by),
      group_by: [pr.created_by_id, c.name],
      select: %{
        id: pr.created_by_id,
        name: c.name,
        count: min(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on))
      },
      having: count(pr.id) > 2,
      order_by: min(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on)),
      limit: 5
    )
    |> Repo.all()
  end

  defp get_longest_lived_pr_creators(year, month) do
    from(pr in PullRequest,
      where:
        pr.status == :completed and
          (^year == 1 or
             (fragment("STRFTIME ('%Y', ?)", pr.closed_on) == ^to_string(year) and
                fragment("STRFTIME ('%m', ?)", pr.closed_on) ==
                  ^String.pad_leading(to_string(month), 2, "0"))),
      join: c in assoc(pr, :created_by),
      group_by: [pr.created_by_id, c.name],
      select: %{
        id: pr.created_by_id,
        name: c.name,
        count: max(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on))
      },
      having: count(pr.id) > 2,
      order_by: [desc: max(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on))],
      limit: 5
    )
    |> Repo.all()
  end
end
