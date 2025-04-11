defmodule Moc.Utils.Float do
  def to_fixed(num, places \\ 2) do
    num |> Decimal.from_float() |> Decimal.round(places)
  end
end
