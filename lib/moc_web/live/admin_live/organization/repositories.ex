defmodule MocWeb.AdminLive.Organization.Repositories do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(_params, _session, socket) do
    socket = socket |> assign(:page_title, "Organizations | Admin")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.admin_content selected_nav="organizations">
      repos
    </.admin_content>
    """
  end
end
