defmodule MocWeb.Admin.DashboardController do
  use MocWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
