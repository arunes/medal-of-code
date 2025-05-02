defmodule MocWeb.MedalLive.Index do
  alias Moc.Scoring
  use MocWeb, :live_view
  import MocWeb.MedalLive.Components, only: [medal_box: 1]

  def mount(_params, _session, socket) do
    medals = Scoring.get_medal_list()
    socket = socket |> assign(:medals, medals)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="grid sm:grid-cols-2 md:grid-cols-3 gap-4 h-full">
      <.medal_box :for={medal <- @medals} medal={medal} />
    </section>
    """
  end
end
