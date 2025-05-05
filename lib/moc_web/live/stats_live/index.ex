defmodule MocWeb.StatsLive.Index do
  use MocWeb, :live_view
  import MocWeb.StatsLive.Components, only: [contribution_calendar: 1]
  import MocWeb.CounterListComponent
  alias Moc.Contributors
  alias Moc.Utils

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-8">
      <.stats />
      <div>
        <.contribution_calendar id="contribution-calendar" />
      </div>
      <div>
        <.title>Counters</.title>
        <.counter_list />
      </div>
    </div>
    """
  end

  def stats(assigns) do
    stats = Contributors.get_all_contributor_stats()

    list = [
      %{title: "Total PRs", value: stats.total_prs, is_date: false},
      %{
        title: "First PR date",
        value: stats.first_pr_date || "N/A",
        is_date: stats.first_pr_date != nil
      },
      %{
        title: "Last PR date",
        value: stats.last_pr_date || "N/A",
        is_date: stats.last_pr_date != nil
      },
      %{
        title: "Avg. PR completion",
        value: Utils.get_duration(stats.avg_completion, 2),
        is_date: false
      },
      %{title: "PR per day", value: stats.pr_per_day |> Float.round(3), is_date: false},
      %{
        title: "Total open PR time",
        value: Utils.get_duration(stats.total_time, 2),
        is_date: false
      },
      %{title: "Total comments", value: stats.total_comments, is_date: false},
      %{title: "Total votes", value: stats.total_votes, is_date: false}
    ]

    assigns = assigns |> assign(:stats, list)

    ~H"""
    <section class="grid gap-4 grid-cols-2 md:grid-cols-4">
      <div
        :for={stat <- @stats}
        class="flex flex-col bg-moc-1 justify-center px-2 pt-1 pb-2 rounded-lg text-center h-24"
      >
        <p>
          <sub>{stat.title}</sub>
        </p>
        <p class="text-lg font-bold">
          <.local_datetime :if={stat.is_date} date={stat.value} format="date" />
          <span :if={!stat.is_date}>{stat.value}</span>
        </p>
      </div>
    </section>
    """
  end
end
