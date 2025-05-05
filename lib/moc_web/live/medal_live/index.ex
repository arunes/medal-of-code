defmodule MocWeb.MedalLive.Index do
  alias Moc.Scoring
  use MocWeb, :live_view
  import MocWeb.MedalLive.Components, only: [medal_box: 1]

  def mount(_params, _session, socket) do
    medals = Scoring.get_medal_list()
    socket = socket |> stream(:medals, medals)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section id="medals" class="grid sm:grid-cols-2 md:grid-cols-3 gap-4 h-full" phx-update="stream">
      <.medal_box :for={{dom_id, medal} <- @streams.medals} medal={medal} id={dom_id} />
    </section>
    """
  end
end
