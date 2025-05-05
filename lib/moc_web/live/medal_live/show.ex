defmodule MocWeb.MedalLive.Show do
  alias Moc.Scoring
  use MocWeb, :live_view
  import MocWeb.MedalLive.Components, only: [medal: 1]
  import MocWeb.ContributorLive.Components, only: [contributor_box: 1]
  alias Moc.Utils

  def mount(%{"id" => medal_id}, _session, socket) do
    Scoring.get_medal(medal_id)
    |> init_mount(socket)
  end

  defp init_mount(nil, socket), do: {:ok, socket |> redirect(to: ~p"/medals")}

  defp init_mount(medal, socket) do
    medal_winners = Scoring.get_medal_winners(medal.id)

    settings = Moc.Instance.get_settings()
    current_contributor_id = socket.assigns.current_user.contributor_id

    contributor_settings = %{
      show_level: settings |> Utils.get_setting_value("contributor.show_level"),
      show_rank: settings |> Utils.get_setting_value("contributor.show_rank"),
      show_medal_count: settings |> Utils.get_setting_value("contributor.show_medal_count")
    }

    socket =
      socket
      |> assign(:page_title, medal.name)
      |> assign(:current_contributor_id, current_contributor_id)
      |> assign(:medal, medal)
      |> assign(:settings, contributor_settings)
      |> assign(:total_winners, length(medal_winners))
      |> stream(:medal_winners, medal_winners)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-12">
      <section>
        <div class="relative flex flex-col items-center">
          <span :if={@settings.show_medal_count} class="absolute inline-flex flex-col top-2 end-3">
            x{@medal.medal_count}
          </span>
          <span class={[
            "absolute inline-flex flex-col top-2 start-3 text-sm",
            @medal.rarity.class_name
          ]}>
            {@medal.rarity.name}
          </span>

          <.medal id={"medal-#{@medal.id}"} name={@medal.name} size={82} affinity={@medal.affinity} />

          <p class="text-2xl text-center">{@medal.name}</p>
          <p class="text-sm text-center text-moc-2">{@medal.description}</p>
        </div>
      </section>
      <section>
        <blockquote class="font-light italic p-4 text-center border-y border-dashed text-moc-2 border-moc-3">
          &quot;{@medal.lore}&quot;
        </blockquote>
      </section>
      <section
        :if={@total_winners > 0}
        id="winners"
        class="grid gap-3 md:grid-cols-2"
        phx-update="stream"
      >
        <.contributor_box
          :for={{dom_id, contributor} <- @streams.medal_winners}
          id={dom_id}
          contributor={contributor}
          show_level={@settings.show_level || @current_contributor_id == contributor.id}
          show_rank={@settings.show_rank}
          show_medal_count={@settings.show_medal_count || @current_contributor_id == contributor.id}
        />
      </section>
      <p class="w-full col-span-full italic text-center text-sm font-light mt-2">
        * {@medal.rarity_percentage |> Float.round(2)}% of contributors have this medal.
      </p>
    </div>
    """
  end
end
