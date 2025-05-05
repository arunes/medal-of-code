defmodule Moc.Contributors do
  import Ecto.Query
  alias Moc.Contributors.Contributor
  alias Moc.Scoring.Medal
  alias Moc.Contributors.ContributorMedal
  alias Moc.PullRequests.PullRequestReview
  alias Moc.PullRequests.PullRequestComment
  alias Moc.PullRequests.PullRequest
  alias Moc.Utils
  alias Moc.Instance
  alias Moc.Repo
  alias Moc.Contributors.ContributorOverview
  alias Moc.Contributors.ContributorActivity

  def get_contributor(contributor_id) do
    Repo.get(ContributorOverview, contributor_id)
  end

  def get_all_activities() do
    from(act in ContributorActivity,
      group_by: [act.date],
      select: %{
        date: act.date,
        count: count(act.date)
      }
    )
    |> Repo.all()
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

  def get_contributor_medals(contributor_id) do
    main_query =
      from(mdl in Medal,
        join: cm in ContributorMedal,
        on: mdl.id == cm.medal_id,
        group_by: [mdl.id, mdl.name, mdl.description, mdl.affinity],
        select: %{
          id: mdl.id,
          name: mdl.name,
          description: mdl.description,
          affinity: mdl.affinity,
          total:
            sum(
              fragment("(CASE WHEN ? == ? THEN 1 ELSE 0 END)", cm.contributor_id, ^contributor_id)
            ),
          contributors_have: count(fragment("DISTINCT ?", cm.contributor_id)),
          last_won_on: max(cm.inserted_at),
          is_new: fragment("JULIANDAY(DATETIME('now')) - JULIANDAY(?)", max(cm.inserted_at)) < 1.0
        }
      )

    contributor_count = from(c in Contributor, select: count(c.id)) |> Repo.one!()

    from(t in subquery(main_query), where: t.total > 0)
    |> Repo.all()
    |> Enum.map(fn medal ->
      rarity_percentage = medal.contributors_have / contributor_count * 100.0

      medal
      |> Map.put(:rarity_percentage, rarity_percentage)
      |> Map.put(:rarity, Utils.get_rarity(rarity_percentage))
    end)
    |> Enum.sort_by(fn medal -> medal.rarity_percentage end)
  end

  def get_contributor_words(contributor_id) do
    common_words = [
      "i",
      "me",
      "my",
      "myself",
      "we",
      "our",
      "ours",
      "ourselves",
      "you",
      "your",
      "yours",
      "yourself",
      "yourselves",
      "he",
      "him",
      "his",
      "himself",
      "she",
      "her",
      "hers",
      "herself",
      "it",
      "its",
      "itself",
      "they",
      "them",
      "their",
      "theirs",
      "themselves",
      "what",
      "which",
      "who",
      "whom",
      "this",
      "that",
      "these",
      "those",
      "am",
      "is",
      "are",
      "was",
      "were",
      "be",
      "been",
      "being",
      "have",
      "has",
      "had",
      "having",
      "do",
      "does",
      "did",
      "doing",
      "a",
      "an",
      "the",
      "and",
      "but",
      "if",
      "or",
      "because",
      "as",
      "until",
      "while",
      "of",
      "at",
      "by",
      "for",
      "with",
      "about",
      "against",
      "between",
      "into",
      "through",
      "during",
      "before",
      "after",
      "above",
      "below",
      "to",
      "from",
      "up",
      "down",
      "in",
      "out",
      "on",
      "off",
      "over",
      "under",
      "again",
      "further",
      "then",
      "once",
      "here",
      "there",
      "when",
      "where",
      "why",
      "how",
      "all",
      "any",
      "both",
      "each",
      "few",
      "more",
      "most",
      "other",
      "some",
      "such",
      "no",
      "nor",
      "not",
      "only",
      "own",
      "same",
      "so",
      "than",
      "too",
      "very",
      "s",
      "t",
      "can",
      "will",
      "just",
      "don",
      "should",
      "now",
      "suggestion"
    ]

    comments =
      from(cmt in PullRequestComment,
        where: cmt.created_by_id == ^contributor_id and cmt.comment_type == :text,
        select: cmt.content
      )
      |> Repo.all()
      |> Enum.join(" ")
      |> String.downcase()
      |> String.replace(~r/http\\S+/, " ")
      |> String.replace(~r/!\[.+\]\(.+\)/, " ")
      |> String.replace(~r/[^a-zA-Z]/, " ")
      |> String.split(" ", trim: true)
      |> Enum.filter(&(String.length(&1) > 2))
      |> Enum.filter(&(!Enum.member?(common_words, &1)))
      |> Enum.group_by(& &1)
      |> Enum.sort_by(fn {_, list} -> length(list) end, :desc)
      |> Enum.map(fn {word, list} -> "#{word}|#{length(list)}" end)
      |> Enum.take(50)

    comments
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
              avg(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on)),
              0.0
            ),
          total_time:
            coalesce(
              sum(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on)),
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

  def get_all_contributor_stats() do
    data =
      from(pr in PullRequest,
        select: %{
          total_prs: count(pr.id),
          first_pr_date: min(pr.created_on),
          last_pr_date: max(pr.created_on),
          avg_completion:
            coalesce(
              avg(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on)),
              0.0
            ),
          total_time:
            coalesce(
              sum(fragment("JULIANDAY(?) - JULIANDAY(?)", pr.closed_on, pr.created_on)),
              0.0
            ),
          total_comments: subquery(from(prc in PullRequestComment, select: count())),
          total_votes: subquery(from(prr in PullRequestReview, select: count()))
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
  defp calculate_pr_per_day(total_prs, date, date), do: total_prs * 1.0

  defp calculate_pr_per_day(total_prs, first_date, last_date),
    do: total_prs / Timex.diff(last_date, first_date, :days)
end
