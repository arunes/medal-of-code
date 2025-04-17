defmodule MocWeb.LeaderboardLive.Index do
  use MocWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    Leaderboard list
    """
  end
end
