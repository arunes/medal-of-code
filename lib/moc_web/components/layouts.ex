defmodule MocWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use MocWeb, :controller` and
  `use MocWeb, :live_view`.
  """
  alias Moc.Utils.Settings
  use MocWeb, :html

  def get_bool_setting(key), do: Settings.get_bool(key)

  embed_templates "layouts/*"
end
