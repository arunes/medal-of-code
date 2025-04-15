defmodule MocWeb.Admin.DashboardLive.Index do
  use MocWeb, :live_view
  import MocWeb.Components.AdminNav

  def render(assigns) do
    ~H"""
    <.admin_nav selected="dashboard" />
    """
  end
end
