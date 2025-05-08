defmodule Moc.Scoring.Counters.OthersPRsCompleted do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, comments: comments}, _get_data) do
    completed_by = who_completed(comments)

    cond do
      is_nil(completed_by) -> []
      completed_by != created_by_id -> [%{contributor_id: completed_by, count: 1}]
      true -> []
    end
  end

  defp who_completed(comments) do
    complete_comment =
      comments
      |> Enum.find(fn cmt ->
        cmt.comment_type == :system &&
          String.ends_with?(cmt.content, "updated the pull request status to Completed")
      end)

    case complete_comment do
      nil -> nil
      cmt -> cmt.created_by_id
    end
  end
end
