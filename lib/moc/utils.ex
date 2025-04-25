defmodule Moc.Utils do
  def utc_now(), do: DateTime.utc_now() |> DateTime.truncate(:second)

  def string_to_utc(str),
    do: str |> DateTime.from_iso8601() |> elem(1) |> DateTime.truncate(:second)

  def nullable_atom(nil), do: nil
  def nullable_atom(value), do: value |> String.to_atom()

  def capitalize_first(<<>>), do: ""
  def capitalize_first(<<c::utf8, rest::binary>>), do: String.upcase(<<c>>) <> rest

  def flatten(input, result \\ [])
  def flatten(input, result) when is_list(input), do: Enum.flat_map(input, &flatten(&1, result))
  def flatten(input, result), do: [input | result]
end
