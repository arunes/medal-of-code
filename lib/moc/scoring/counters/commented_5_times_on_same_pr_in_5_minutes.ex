defmodule Moc.Scoring.Counters.Commented5TimesOnSamePRIn5Minutes do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == :text))
    |> Enum.map(fn comment ->
      five_min_in_future = NaiveDateTime.add(comment.published_on, 5 * 60, :second)

      number_of_comments =
        Enum.count(comments, fn uc ->
          uc.comment_type == :text &&
            uc.created_by_id == comment.created_by_id &&
            (NaiveDateTime.compare(uc.published_on, comment.published_on) == :eq ||
               NaiveDateTime.compare(uc.published_on, comment.published_on) == :gt) &&
            NaiveDateTime.compare(uc.published_on, five_min_in_future) == :lt
        end)

      %{contributor_id: comment.created_by_id, total_comments: number_of_comments}
    end)
    |> Enum.filter(&(&1.total_comments >= 5))
    |> Enum.map(& &1.contributor_id)
    |> Enum.uniq()
    |> Enum.map(fn contributor_id -> %{contributor_id: contributor_id, count: 1} end)
  end
end
