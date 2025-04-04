defmodule Moc.Counters.Helpers do
  @doc """
  Groups the comment by user id and counts the number of records
  """
  def result_by_count(comments) do
    comments
    |> Enum.group_by(& &1.created_by_id)
    |> Enum.map(fn {created_by_id, list} ->
      %{contributor_id: created_by_id, count: length(list)}
    end)
  end

  @doc """
  Groups the comment by user id and sums the 'count' field
  """
  def result_by_sum(comments) do
    comments
    |> Enum.group_by(& &1.contributor_id)
    |> Enum.map(fn {contributor_id, list} ->
      %{contributor_id: contributor_id, count: Enum.sum_by(list, & &1.count)}
    end)
  end
end
