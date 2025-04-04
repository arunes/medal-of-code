defmodule Moc.Sync.Impl.Counters.CommentedOnPR do
  alias Moc.Sync.Type
  alias Moc.Data.Schema

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    comments
    |> Enum.filter(&(&1.comment_type == "text"))
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
