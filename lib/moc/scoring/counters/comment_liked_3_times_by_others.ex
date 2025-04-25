defmodule Moc.Scoring.Counters.CommentLiked3TimesByOthers do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&filter_likes/1)
    |> Helpers.result_by_comment_count()
  end

  defp filter_likes(comment) do
    comment.comment_type == :text and
      comment.liked_by
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reject(&(&1 == comment.created_by_id))
      |> length
      |> Kernel.>=(3)
  end
end
