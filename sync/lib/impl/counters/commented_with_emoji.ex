defmodule Moc.Sync.Impl.Counters.CommentedWithEmoji do
  alias Moc.Data.Schema
  alias Moc.Sync.Type

  @regex ~r/\p{So}/u

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == "text" && cmt.content =~ @regex end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
