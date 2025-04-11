defmodule MocWeb.MedalHTML do
  use MocWeb, :html
  import MocWeb.Components
  import Moc.Utils.Float, only: [to_fixed: 2]

  embed_templates "templates/medal/*"
end
