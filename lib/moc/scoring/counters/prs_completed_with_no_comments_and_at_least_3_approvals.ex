defmodule Moc.Scoring.Counters.PrsCompletedWithNoCommentsAndAtLeast3Approvals do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(
        %Type.Input{
          created_by_id: created_by_id,
          status: status,
          comments: comments,
          reviews: reviews
        },
        _get_data
      ) do
    match? =
      status == :completed && Enum.count(comments, &(&1.comment_type == :text)) == 0 &&
        Enum.count(reviews, &(&1.vote > 0)) >= 3

    case match? do
      true -> [%{contributor_id: created_by_id, count: 1}]
      false -> []
    end
  end
end
