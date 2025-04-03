defmodule Moc.Utils.List do
  @spec flatten(list(), list()) :: list()
  def flatten(input, result \\ [])
  def flatten(input, result) when is_list(input), do: Enum.flat_map(input, &flatten(&1, result))
  def flatten(input, result), do: [input | result]
end
