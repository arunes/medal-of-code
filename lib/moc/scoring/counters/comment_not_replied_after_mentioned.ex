defmodule Moc.Scoring.Counters.CommentNotRepliedAfterMentioned do
  alias Moc.Scoring.Counters.Type

  @regex ~r/@<([{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?)>/

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.flat_map(&extract_external_ids(&1, get_data))
    |> Enum.reject(&has_later_comment?(&1, comments))
    |> Enum.map(&count_contributor/1)
  end

  defp extract_external_ids(comment, get_data) do
    Regex.scan(@regex, comment.content)
    |> Enum.map(fn [_, external_id | _] -> String.downcase(external_id) end)
    |> Enum.uniq()
    |> Enum.map(fn external_id ->
      %{
        contributor_id: get_data.(:contributor_by_id, external_id),
        published_on: comment.published_on,
        thread_id: comment.thread_id
      }
    end)
  end

  defp has_later_comment?(
         %{
           contributor_id: contributor_id,
           published_on: published_on,
           thread_id: thread_id
         },
         comments
       ) do
    Enum.any?(comments, fn cmt ->
      cmt.thread_id == thread_id and
        NaiveDateTime.compare(cmt.published_on, published_on) == :gt and
        cmt.created_by_id == contributor_id
    end)
  end

  defp count_contributor(%{contributor_id: contributor_id}),
    do: %{contributor_id: contributor_id, count: 1}
end
