defmodule MocWeb.MedalLive.Index do
  use MocWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    Medal list
    """
  end
end
