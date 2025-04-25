defmodule Moc.Scoring.Counters.CommentsRepliedAtLeast3Others do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.sort_by(fn cmt -> cmt.published_on end)
    |> Enum.group_by(& &1.thread_id)
    |> Enum.filter(fn {_, list} -> has_3_replies?(list) end)
    |> Enum.map(fn {_, list} -> get_author(list) end)
    |> Helpers.result_by_comment_sum()
  end

  defp has_3_replies?([author | replies]) do
    replies
    |> Enum.filter(fn cmt -> cmt.created_by_id != author.created_by_id end)
    |> length()
    |> Kernel.>=(3)
  end

  defp get_author([author | _]) do
    %{contributor_id: author.created_by_id, count: 1}
  end
end
