defmodule Moc.Utils.Settings do
  alias Moc.Runtime.Setup

  def get_bool(key) do
    case Setup.get_settings() |> Enum.find(fn st -> st.key == key end) do
      nil -> false
      setting -> setting.value == "true"
    end
  end
end
