defmodule Moc.Scoring.Counters.CommentsLiked do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == :text && cmt.liked_by != "" end)
    |> Enum.flat_map(fn cmt ->
      cmt.liked_by
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn id -> %{contributor_id: id, count: 1} end)
    |> Helpers.result_by_comment_sum()
  end
end
