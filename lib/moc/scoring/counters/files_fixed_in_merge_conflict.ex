defmodule Moc.Scoring.Counters.FilesFixedInMergeConflict do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&is_merge_conflict_comment/1)
    |> Enum.map(&select_result/1)
  end

  defp is_merge_conflict_comment(%{type: type}) when type != "text", do: false

  defp is_merge_conflict_comment(%{content: content}),
    do: content =~ "Submitted conflict resolution for the file(s)."

  defp select_result(comment) do
    %{
      contributor_id: comment.created_by_id,
      count: count_merge_conflicts(comment.content)
    }
  end

  defp count_merge_conflicts(content) do
    content
    |> String.split("\n")
    |> length()
    |> Kernel.-(1)
  end
end
