defmodule MocWeb.LeaderboardLive.Index do
  alias Moc.Leaderboard
  use MocWeb, :live_view

  def mount(_params, _session, socket) do
    boards = Leaderboard.get_list(DateTime.utc_now())

    socket =
      socket
      |> assign(:page_title, "Leaderboard")
      |> stream(:boards, boards)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section id="boards" class="grid lg:grid-cols-2 gap-10" phx-update="stream">
      <div class="lg:col-span-2">
        filter
      </div>
      <div :for={{dom_id, board} <- @streams.boards} id={dom_id}>
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
      </div>
    </section>
    """
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
