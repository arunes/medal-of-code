defmodule Moc.Scoring.Counters.MentionedSomeoneInPROrComment do
  alias Moc.Scoring.Counters.Type

  @regex ~r/@<([{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?)>/

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(
        %Type.Input{comments: comments, created_by_id: created_by_id, description: description},
        _get_data
      ) do
    get_result_for_comments(comments |> Enum.filter(&(&1.comment_type == :text))) ++
      get_result_for_pr(created_by_id, description)
  end

  defp get_result_for_pr(created_by_id, description) do
    mentions = get_mentions(description)

    cond do
      length(mentions) > 0 -> [%{contributor_id: created_by_id, count: 1}]
      true -> []
    end
  end

  defp get_result_for_comments(comments) do
    comments
    |> Enum.map(fn cmt -> Map.put(cmt, :mentions, get_mentions(cmt.content)) end)
    |> Enum.filter(fn cmt -> length(cmt.mentions) > 0 end)
    |> Enum.map(fn cmt -> %{contributor_id: cmt.created_by_id, count: 1} end)
  end

  defp get_mentions(text) when is_binary(text) do
    @regex
    |> Regex.scan(text)
    |> Enum.map(&(Enum.at(&1, 1) |> String.downcase()))
    |> Enum.uniq()
  end

  defp get_mentions(_text), do: []
end
