defmodule Moc.Sync.Impl.Counters.CommentedOnPRAfterCompleted do
  alias Moc.Db.Schema
  alias Moc.Sync.Type

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{closed_on: closed_on, comments: comments}) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == "text" and
        NaiveDateTime.compare(cmt.published_on, closed_on) == :gt
    end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end
end
