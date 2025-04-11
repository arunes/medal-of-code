defmodule MocWeb.HomeHTML do
  use MocWeb, :html
  import MocWeb.Components.HistoryList

  embed_templates "templates/home/*"
end
