defmodule Moc.Sync.Impl.Counters.CommentLikedByOthers do
  alias Moc.Db.Schema
  alias Moc.Sync.Type

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    count_likes = fn liked_by, author_id ->
      liked_by |> String.split(",", trim: true) |> Enum.count(&(&1 != author_id))
    end

    comments
    |> Enum.filter(&(&1.comment_type == "text" and &1.liked_by != ""))
    |> Enum.map(fn cmt ->
      %{contributor_id: cmt.created_by_id, count: count_likes.(cmt.liked_by, cmt.created_by_id)}
    end)
  end
end
