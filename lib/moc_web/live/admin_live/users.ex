defmodule MocWeb.AdminLive.Users do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(_params, _session, socket) do
    socket = socket |> assign(:page_title, "Users | Admin")

    {:ok, socket}
  end

  def render(assigns) do
    breadcrumb = [%{link: "", label: "Users"}]
    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="users" breadcrumb={@breadcrumb}>
      TODO!
    </.admin_content>
    """
  end
end
