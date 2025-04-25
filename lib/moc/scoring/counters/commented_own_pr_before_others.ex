defmodule Moc.Scoring.Counters.CommentedOwnPRBeforeOthers do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: pr_created_by, comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.sort_by(fn cmt -> cmt.published_on end)
    |> get_result(pr_created_by)
  end

  defp get_result([], _), do: []

  defp get_result([first | _], pr_created_by) when first.created_by_id == pr_created_by,
    do: [%{contributor_id: first.created_by_id, count: 1}]

  defp get_result(_, _), do: []
end
