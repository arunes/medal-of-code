defmodule Moc.Sync.Counters.CommentedOnPR do
  alias Moc.Sync.Counters.Helpers
  alias Moc.Sync.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(&(&1.comment_type == "text"))
    |> Helpers.result_by_count()
  end
end
