defmodule MocWeb.HomeHTML do
  use MocWeb, :html
  import MocWeb.Components.HistoryList
  import MocWeb.Components.Common

  embed_templates "templates/home/*"
end
