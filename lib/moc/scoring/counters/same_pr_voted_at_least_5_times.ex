defmodule Moc.Scoring.Counters.SamePRVotedAtLeast5Times do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == :system && cmt.content =~ ~r/voted -?\d+$/ end)
    |> Enum.map(& &1.created_by_id)
    |> Enum.group_by(& &1)
    |> Enum.filter(fn {_, list} -> length(list) >= 5 end)
    |> Enum.map(fn {id, _} -> %{contributor_id: id, count: 1} end)
  end
end
