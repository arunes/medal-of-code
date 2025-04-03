defmodule Moc.Sync.Impl.Counters.PrsCompletedWithAtLeast10Comments10Reviewers10Votes do
  alias Moc.Db.Schema
  alias Moc.Sync.Type

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    # %{contributor_id: contributor_id, count: 1}
    []
  end
end
