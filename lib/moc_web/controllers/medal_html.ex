defmodule MocWeb.MedalHTML do
  use MocWeb, :html
  import MocWeb.Components.Medal
  import MocWeb.Components.ContributorBox
  import Moc.Utils.Float, only: [to_fixed: 2]

  embed_templates "templates/medal/*"
end
