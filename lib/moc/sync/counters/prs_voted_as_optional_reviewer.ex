defmodule Moc.Sync.Counters.PrsVotedAsOptionalReviewer do
  alias Moc.Sync.Counters.Type
  
  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(_input, _get_data) do
    # %{contributor_id: contributor_id, count: 1}
    []
  end
end
