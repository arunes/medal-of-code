defmodule MocWeb.AdminLive.Index do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Dashboard | Admin")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.admin_content selected_nav="dashboard">
      TODO!
    </.admin_content>
    """
  end
end
