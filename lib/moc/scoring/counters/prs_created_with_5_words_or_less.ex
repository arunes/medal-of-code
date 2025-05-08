defmodule Moc.Scoring.Counters.PrsCreatedWith5WordsOrLess do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, description: description}, _get_data) do
    case get_word_count(description) <= 5 do
      true -> [%{contributor_id: created_by_id, count: 1}]
      false -> []
    end
  end

  defp get_word_count(nil), do: 0
  defp get_word_count(text), do: String.split(text, " ") |> length()
end
