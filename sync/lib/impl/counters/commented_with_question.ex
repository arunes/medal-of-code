defmodule Moc.Sync.Impl.Counters.CommentedWithQuestion do
  alias Moc.Data.Schema
  alias Moc.Sync.Type

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == "text" && String.ends_with?(cmt.content, "?")
    end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
