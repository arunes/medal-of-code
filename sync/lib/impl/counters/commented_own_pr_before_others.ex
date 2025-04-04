defmodule Moc.Sync.Impl.Counters.CommentedOwnPRBeforeOthers do
  alias Moc.Data.Schema
  alias Moc.Sync.Type

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{created_by_id: pr_created_by, comments: comments}) do
    comments
    |> Enum.filter(&(&1.comment_type == "text"))
    |> Enum.sort_by(fn cmt -> cmt.published_on end)
    |> get_result(pr_created_by)
  end

  defp get_result([], _), do: []

  defp get_result([first | _], pr_created_by) when first.created_by_id == pr_created_by,
    do: [%{contributor_id: first.created_by_id, count: 1}]

  defp get_result(_, _), do: []
end
