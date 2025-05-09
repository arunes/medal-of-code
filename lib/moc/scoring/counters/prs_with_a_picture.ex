defmodule Moc.Scoring.Counters.PrsWithAPicture do
  alias Moc.Scoring.Counters.Type

  @spec count(Type.Input.t(), fun()) :: list(Type.counter_result())
  def count(%Type.Input{created_by_id: created_by_id, description: description}, _get_data) do
    case has_image?(description) do
      true -> [%{contributor_id: created_by_id, count: 1}]
      false -> []
    end
  end

  defp has_image?(nil), do: false
  defp has_image?(text), do: text =~ ~r/\!\[.+(png|jpg|jpeg|gif)\]/
end
