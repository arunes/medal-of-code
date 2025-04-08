defmodule MocWeb.PageController do
  use MocWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
