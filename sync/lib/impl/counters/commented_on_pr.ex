defmodule Moc.Sync.Impl.Counters.CommentedOnPR do
  alias Moc.Db.Schema

  def count(%Schema.PullRequest{comments: comments}) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == "text" end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
