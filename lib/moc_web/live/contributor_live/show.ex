defmodule MocWeb.ContributorLive.Show do
  import MocWeb.HistoryListComponent
  use MocWeb, :live_view
  alias Moc.Contributors
  alias Moc.Utils

  def mount(%{"id" => contributor_id}, _session, socket) do
    contributor = Contributors.get_contributor!(contributor_id)
    settings = Moc.Instance.get_settings()
    contributor_id = socket.assigns.current_user.contributor_id

    contributor_settings = %{
      show_level: settings |> Utils.get_setting_value("contributor.show_level"),
      show_rank: settings |> Utils.get_setting_value("contributor.show_rank"),
      show_affinity: settings |> Utils.get_setting_value("contributor.show_affinity"),
      show_medal_count: settings |> Utils.get_setting_value("contributor.show_medal_count"),
      show_attributes: settings |> Utils.get_setting_value("contributor.show_attributes"),
      show_history: settings |> Utils.get_setting_value("contributor.show_history"),
      show_calendar: settings |> Utils.get_setting_value("contributor.show_history"),
      show_numbers: settings |> Utils.get_setting_value("contributor.show_history"),
      show_stats: settings |> Utils.get_setting_value("contributor.show_history"),
      show_wordcloud: settings |> Utils.get_setting_value("contributor.show_history")
    }

    show_activity =
      contributor_settings.show_calendar || contributor_settings.show_numbers ||
        contributor_settings.show_stats || contributor_settings.show_wordcloud

    socket =
      socket
      |> assign(:page_title, contributor.name)
      |> assign(:contributor_id, contributor_id)
      |> assign(:contributor, contributor)
      |> assign(:show_activity, show_activity)
      |> assign(:settings, contributor_settings)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="contributor space-y-12">
      <section class="space-y-6">
        <.header contributor={@contributor} show_rank={@settings.show_rank} />

        <.attributes
          :if={@settings.show_attributes || @contributor.id == @contributor_id}
          contributor={@contributor}
        />

        <.progress_bar
          :if={@contributor.id == @contributor_id || @settings.show_level || @settings.show_affinity}
          show_level={@settings.show_level}
          show_affinity={@settings.show_affinity}
          contributor={@contributor}
        />
      </section>

      <section class="grid sm:grid-cols-2 md:grid-cols-3 gap-4 h-full">medals</section>

      <div :if={@contributor.id == @contributor_id || @show_activity}>
        <.title size="xl">Activity</.title>
      </div>

      <div :if={@contributor.id == @contributor_id || @settings.show_history}>
        <.title size="xl">History</.title>
        <.history_list
          number_of_records={10}
          contributor_id={@contributor.id}
          current_contributor_id={@contributor_id}
        />
      </div>
    </div>
    """
  end

  def header(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <div class="relative inline-flex">
        <.avatar id={@contributor.id} class="mb-2" name={@contributor.name} size={128} />

        <span
          :if={@show_rank}
          class="absolute rank flex items-center justify-center size-10 -top-2 -end-2 rounded-full p-1"
        >
          <span class="font-extrabold text-xl">
            {@contributor.rank}
          </span>
          <sup>{Utils.get_ordinal(@contributor.rank)}</sup>
        </span>
      </div>
      <p class="text-2xl text-center">{@contributor.name}</p>
      <p class="text-sm text-center tagLine">
        {Utils.get_tag_line(
          @contributor.prefix,
          @contributor.title,
          @contributor.number_of_medals,
          @contributor.level
        )}
      </p>
    </div>
    """
  end

  defp attributes(assigns) do
    attributes = [
      %{
        name: "DEX",
        full_name: "Dexterity",
        value: assigns.contributor.dexterity
      },
      %{
        name: "WIS",
        full_name: "Wisdom",
        value: assigns.contributor.wisdom
      },
      %{
        name: "CHA",
        full_name: "Charisma",
        value: assigns.contributor.charisma
      },
      %{
        name: "CON",
        full_name: "Constitution",
        value: assigns.contributor.constitution
      }
    ]

    assigns = assigns |> assign(:attributes, attributes)

    ~H"""
    <div class="mt-2">
      <div class="mx-auto max-w-lg grid grid-cols-4 gap-2">
        <div :for={attr <- @attributes} class="text-center border border-moc-2">
          <p class="bg-moc-2 p-1 text-sm text-moc-2" title={attr.full_name}>
            {attr.name}
          </p>
          <p class="bg-moc p-1">{attr.value}</p>
        </div>
      </div>
    </div>
    """
  end

  def progress_bar(assigns) do
    level_percent =
      get_level_percent(assigns.contributor.xp_needed, assigns.contributor.xp_progress)

    assigns = assigns |> assign(:level_percent, level_percent)

    ~H"""
    <div>
      <div :if={@show_level} class="flex justify-between mb-1">
        <span class="font-medium">
          Level {@contributor.level || 1} {@contributor.prefix} {@contributor.title}
        </span>
        <span :if={@level_percent} class="text-sm font-medium">
          {@level_percent |> Float.floor(2)}%
        </span>
      </div>

      <div
        role="progressbar"
        class="w-full rounded-t-sm h-5 progressBar"
        title={!@contributor.xp_needed && "Max Level"}
        title={
          @contributor.xp_needed &&
            "#{@contributor.xp_needed} xp needed to reach level #{@contributor.level + 1}."
        }
      >
        <div class="h-5 rounded-t-sm" style={"width: #{@level_percent || 100}%"}></div>
      </div>

      <div role="progressbar" class="w-full rounded-b-sm h-1 lightBar">
        <div class="h-1 rounded-b-sm" style={"width: #{@contributor.light_percent}%"}></div>
      </div>
      <div class="mt-1">
        <p class="text-sm font-light">
          Affinity: <span :if={@contributor.light_percent < 50} class="affinity-dark">Dark</span>
          <span :if={@contributor.light_percent > 50} class="affinity-light">Light</span>
          <span :if={@contributor.light_percent == nil || @contributor.light_percent == 50}>
            Neutral
          </span>
        </p>
      </div>
    </div>
    """
  end

  def history(assigns) do
    ~H"""
    <div>history</div>
    """
  end

  defp get_level_percent(nil, _), do: nil
  defp get_level_percent(xp_needed, xp_progress), do: xp_progress / xp_needed * 100
end

# title={
#   @contributor.xp_needed
#     ? `${formatNumber(
#         @contributor.xp_needed
#       )} xp needed to reach level ${@contributor.level + 1}`
#     : "Max Level"
# }
