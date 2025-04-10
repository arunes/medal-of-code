defmodule Moc.Sync.Counters.CommentedAllUppercase do
  alias Moc.Sync.Counters.Helpers
  alias Moc.Sync.Counters.Type

  @regex_not_lowercase ~r/^[^a-z]{4,}$/
  @regex_uppercase ~r/[A-Z]/

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt ->
      cmt.comment_type == "text" and
        cmt.content =~ @regex_not_lowercase and
        cmt.content =~ @regex_uppercase
    end)
    |> Helpers.result_by_count()
  end
end
