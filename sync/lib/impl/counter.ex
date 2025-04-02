defmodule Moc.Sync.Impl.Counter do
  alias Moc.Sync.Impl.Counters

  def count("commentedOnPR", pull_request), do: Counters.CommentedOnPr.count(pull_request)
end
