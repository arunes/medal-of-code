defmodule Moc.Scoring.Counters.MergeConflictsResolved do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.filter(fn cmt ->
      String.starts_with?(cmt.content, "Submitted conflict resolution for the file(s).")
    end)
    |> Enum.map(fn cmt ->
      %{
        contributor_id: cmt.created_by_id,
        count: 1
      }
    end)
  end
end
