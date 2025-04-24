defmodule Moc.Utils do
  def utc_now(), do: DateTime.utc_now() |> DateTime.truncate(:second)

  def string_to_utc(str),
    do: str |> DateTime.from_iso8601() |> elem(1) |> DateTime.truncate(:second)

  def if_nil(val, default \\ "")
  def if_nil(nil, default), do: default
  def if_nil(val, _default), do: val

  def nullable_atom(nil), do: nil
  def nullable_atom(value), do: value |> String.to_atom()
end
