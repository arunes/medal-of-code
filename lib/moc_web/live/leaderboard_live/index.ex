defmodule MocWeb.LeaderboardLive.Index do
  alias Moc.Utils
  alias Moc.Instance
  alias Moc.Leaderboard
  use MocWeb, :live_view

  def mount(_params, _session, socket) do
    last_month = Date.utc_today() |> Timex.shift(months: -1)
    params = %{"date" => Date.to_iso8601(last_month)}
    boards = Leaderboard.get_list(params)

    socket =
      socket
      |> assign(:page_title, "Leaderboard")
      |> assign(:form, to_form(params))
      |> stream(:boards, boards)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mb-5">
      <.filter_form form={@form} />
    </div>
    <section id="boards" class="grid lg:grid-cols-2 gap-10" phx-update="stream">
      <div :for={{dom_id, board} <- @streams.boards} class="min-h-24" id={dom_id}>
        <h1 class="text-xl text-center mb-2">{board.title}</h1>
        <.table
          :if={length(board.data) > 0}
          hide_header
          id={"board-#{board.id}-people"}
          class="max-w-lg mx-auto"
          rows={board.data}
          row_click={fn row -> JS.navigate(~p"/contributors/#{row.id}") end}
        >
          <:col :let={c}>
            <span class={row_class(c.rank)}>{medal_icon(c.rank)}</span>
          </:col>
          <:col :let={c} class="w-full"><span class={row_class(c.rank)}>{c.name}</span></:col>
          <:col :let={c} class="whitespace-nowrap" align="right">
            <span class={row_class(c.rank)}>{board.formatter.(c.count)}</span>
          </:col>
        </.table>
        <p :if={length(board.data) == 0} class="text-center text-moc-2">
          &quot;Awaiting champions. Seize your mouse and keyboard, for glory calls to
          those who code!&quot;
        </p>
      </div>
    </section>
    """
  end

  def handle_event("filter", params, socket) do
    boards = Leaderboard.get_list(params) |> IO.inspect()

    socket =
      socket
      |> assign(:form, to_form(params))
      |> stream(:boards, boards)

    {:noreply, socket}
  end

  attr :form, :any
  attr :show_all_time, :boolean

  defp filter_form(assigns) do
    today = Date.utc_today()

    show_all_time =
      Instance.get_settings() |> Utils.get_setting_value("leaderboard.show_all_time")

    dates =
      1..5
      |> Enum.map(fn n ->
        date = today |> Timex.shift(months: -n)
        {Calendar.strftime(date, "%B %Y"), Date.to_iso8601(date)}
      end)
      |> maybe_add_all_time_option(show_all_time)

    assigns = assigns |> assign(:dates, dates)

    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input
        type="select"
        class="mx-auto block px-4 py-3 border border-moc-3 rounded-lg bg-moc-3"
        field={@form[:date]}
        options={@dates}
      />
    </.form>
    """
  end

  defp maybe_add_all_time_option(dates, false) do
    dates
  end

  defp maybe_add_all_time_option(dates, true) do
    [{"All Time", Date.new!(1, 1, 1) |> Date.to_iso8601()} | dates]
  end

  defp medal_icon(1), do: "🥇"
  defp medal_icon(2), do: "🥈"
  defp medal_icon(3), do: "🥉"
  defp medal_icon(4), do: "4th"
  defp medal_icon(5), do: "5th"

  defp row_class(1), do: "text-lg"
  defp row_class(2), do: ""
  defp row_class(3), do: "text-sm"
  defp row_class(4), do: "text-slate-500 text-xs"
  defp row_class(5), do: "text-slate-500 text-xs"
end
