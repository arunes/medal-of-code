defmodule Moc.Scoring.Counters.CommentedWithPicture do
  alias Moc.Scoring.Counters.Helpers
  alias Moc.Scoring.Counters.Type

  @regex ~r/!\[.+(png|jpg|jpeg|gif)\]/

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == :text && cmt.content =~ @regex end)
    |> Helpers.result_by_comment_count()
  end
end
