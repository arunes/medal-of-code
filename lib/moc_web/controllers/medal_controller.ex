defmodule MocWeb.MedalController do
  alias Moc.Medal
  use MocWeb, :controller

  def index(conn, _params) do
    medals = Medal.get_list()
    render(conn, :index, medals: medals)
  end

  def detail(conn, %{"id" => id}) do
    medal = Medal.get_medal(id)

    render(conn, :detail, medal: medal)
  end
end
