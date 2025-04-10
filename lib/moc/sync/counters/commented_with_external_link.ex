defmodule Moc.Sync.Counters.CommentedWithExternalLink do
  alias Moc.Sync.Counters.Helpers
  alias Moc.Sync.Counters.Type

  @regex ~r/(\b(https?|ftp|file):\/\/((?!dev\.azure\.com).)[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{comments: comments}, _get_data) do
    comments
    |> Enum.filter(fn cmt -> cmt.comment_type == "text" && cmt.content =~ @regex end)
    |> Helpers.result_by_count()
  end
end
