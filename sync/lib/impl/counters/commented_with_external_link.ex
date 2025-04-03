defmodule Moc.Sync.Impl.Counters.CommentedWithExternalLink do
  alias Moc.Db.Schema
  alias Moc.Sync.Type

  @regex ~r/(\b(https?|ftp|file):\/\/((?!dev\.azure\.com).)[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == "text" && cmt.content =~ @regex end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
