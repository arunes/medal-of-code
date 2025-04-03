defmodule Moc.Sync.Impl.Counters.Commented25TimesOnSamePR do
  alias Moc.Db.Schema
  alias Moc.Sync.Type

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    comments
    |> Enum.filter(&(&1.comment_type == "text"))
    |> Enum.map(fn comment ->
      number_of_comments =
        comments
        |> Enum.count(&(&1.comment_type == "text" and &1.created_by_id == comment.created_by_id))

      %{contributor_id: comment.created_by_id, total_comments: number_of_comments}
    end)
    |> Enum.filter(&(&1.total_comments >= 25))
    |> Enum.map(& &1.contributor_id)
    |> Enum.uniq()
    |> Enum.map(fn contributor_id -> %{contributor_id: contributor_id, count: 1} end)
  end
end
