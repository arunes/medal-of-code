defmodule Moc.Sync.Impl.Counters.PrsCreatedWith5WordsOrLess do
  alias Moc.Data.Schema
  alias Moc.Sync.Type

  @spec count(Schema.PullRequest.t()) :: list(Type.counter_result())
  def count(%Schema.PullRequest{comments: comments}) do
    # %{contributor_id: contributor_id, count: 1}
    []
  end
end
