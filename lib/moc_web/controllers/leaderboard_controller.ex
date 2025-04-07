defmodule MocWeb.LeaderboardController do
  use MocWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
