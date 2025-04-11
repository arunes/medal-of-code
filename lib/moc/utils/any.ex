defmodule Moc.Utils.Any do
  def if_nil(val, default \\ "")
  def if_nil(nil, default), do: default
  def if_nil(val, _default), do: val
end
