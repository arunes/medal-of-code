defmodule MocWeb.AdminLive.Settings do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(_params, _session, socket) do
    socket = socket |> assign(:page_title, "Settings | Admin")

    {:ok, socket}
  end

  def render(assigns) do
    breadcrumb = [%{link: "", label: "Settings"}]
    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="settings" breadcrumb={@breadcrumb}>
      settings
    </.admin_content>
    """
  end
end
