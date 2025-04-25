defmodule Moc.Scoring.Counters.Helpers do
  @doc """
  Takes a list of comments and returns a list of maps with the contributor_id and count
  of comments per contributor.

  ## Examples

      iex> result_by_comment_count([%{created_by_id: 1}, %{created_by_id: 1}, %{created_by_id: 2}])
      [%{contributor_id: 1, count: 2}, %{contributor_id: 2, count: 1}]

  """
  def result_by_comment_count(comments) do
    comments
    |> Enum.group_by(& &1.created_by_id)
    |> Enum.map(fn {created_by_id, list} ->
      %{contributor_id: created_by_id, count: length(list)}
    end)
  end

  @doc """
  Takes a list of comments and returns a list of maps with the contributor_id and sum
  of counts per contributor.

  ## Examples

      iex> result_by_comment_sum([%{contributor_id: 1, count: 2}, %{contributor_id: 1, count: 3}, %{contributor_id: 2, count: 1}])
      [%{contributor_id: 1, count: 5}, %{contributor_id: 2, count: 1}]

  """
  def result_by_comment_sum(comments) do
    comments
    |> Enum.group_by(& &1.contributor_id)
    |> Enum.map(fn {contributor_id, list} ->
      %{contributor_id: contributor_id, count: Enum.sum_by(list, & &1.count)}
    end)
  end
end
