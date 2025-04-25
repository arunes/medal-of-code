defmodule Moc.Scoring.Counters.CommentsRepliedLessThan5Minutes do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.sort_by(fn cmt -> cmt.published_on end)
    |> Enum.group_by(& &1.thread_id)
    |> Enum.filter(fn {_, list} -> length(list) > 1 end)
    |> Enum.flat_map(fn {_, list} -> who_replied_in_5_minutes(list) end)
    |> Helpers.result_by_comment_sum()
  end

  defp who_replied_in_5_minutes([author | replies]) do
    reply_window = NaiveDateTime.add(author.published_on, 5 * 60, :second)

    replies
    |> Enum.filter(fn cmt -> cmt.created_by_id != author.created_by_id end)
    |> Enum.filter(fn cmt ->
      NaiveDateTime.compare(cmt.published_on, reply_window) == :lt
    end)
    |> Enum.map(& &1.created_by_id)
    |> Enum.uniq()
    |> Enum.map(&%{contributor_id: &1, count: 1})
  end
end
