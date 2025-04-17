defmodule MocWeb.LeaderboardLive.Show do
  use MocWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    Leaderboard detail
    """
  end
end
