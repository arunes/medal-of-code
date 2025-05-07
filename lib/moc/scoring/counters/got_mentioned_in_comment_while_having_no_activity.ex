defmodule Moc.Scoring.Counters.GotMentionedInCommentWhileHavingNoActivity do
  alias Moc.Scoring.Counters.Type

  @regex ~r/@<([{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?)>/

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(
        %Type.Input{comments: comments, created_by_id: created_by_id, reviews: reviews},
        get_data
      ) do
    result =
      comments
      |> Enum.filter(&(&1.comment_type == :text))
      |> get_comments_with_mentions()
      |> get_first_time_mentions(created_by_id, comments, reviews)
      |> Enum.uniq()
      |> Enum.map(
        &%{
          contributor_id: get_data.(:contributor_by_id, &1),
          count: 1
        }
      )

    result
  end

  defp get_comments_with_mentions(comments) do
    comments
    |> Enum.map(&add_mentions/1)
    |> Enum.filter(&Enum.any?(&1.mentions))
  end

  defp add_mentions(comment) do
    mentions =
      @regex
      |> Regex.scan(comment.content)
      |> Enum.map(&(Enum.at(&1, 1) |> String.downcase()))
      |> Enum.uniq()

    Map.put(comment, :mentions, mentions)
  end

  defp get_first_time_mentions(
         comments_with_mentions,
         created_by_id,
         all_comments,
         reviews,
         result \\ []
       )

  defp get_first_time_mentions([], _created_by_id, _all_comments, _reviews, result), do: result

  defp get_first_time_mentions(
         [comment | rest],
         created_by_id,
         all_comments,
         reviews,
         result
       ) do
    new_mentions =
      comment.mentions
      |> Enum.filter(&first_time_mention?(&1, created_by_id, comment, all_comments, reviews))

    get_first_time_mentions(rest, created_by_id, all_comments, reviews, new_mentions ++ result)
  end

  defp first_time_mention?(mention_id, created_by_id, comment, all_comments, reviews) do
    mention_id != created_by_id and
      not Enum.any?(reviews, &(&1.reviewer_id == mention_id)) and
      not Enum.any?(all_comments, fn other_comment ->
        other_comment.created_by_id == mention_id and
          other_comment.published_on < comment.published_on
      end)
  end
end
