defmodule Moc.Utils.String do
  @spec capitalize_first(String.t()) :: String.t()
  def capitalize_first(<<>>), do: ""
  def capitalize_first(<<c::utf8, rest::binary>>), do: String.upcase(<<c>>) <> rest
end
