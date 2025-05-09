defmodule Moc.Scoring.Counters.PrsVotedWaitingForAuthor do
  alias Moc.Scoring.Counters.Type

  # 10 - approved 
  # 5 - approved with suggestions
  # 0 - no vote 
  # -5 - waiting for author
  # -10 - rejected

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == :system && String.ends_with?(cmt.content, "voted -5")
    end)
    |> Enum.map(&%{contributor_id: &1.created_by_id, count: 1})
  end
end
