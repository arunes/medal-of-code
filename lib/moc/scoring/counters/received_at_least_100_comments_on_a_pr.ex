defmodule Moc.Scoring.Counters.ReceivedAtLeast100CommentsOnAPR do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, comments: comments}, _get_data) do
    has_100_comments? = Enum.count(comments, &(&1.comment_type == :text)) >= 100

    case has_100_comments? do
      true -> [%{contributor_id: created_by_id, count: 1}]
      false -> []
    end
  end
end
