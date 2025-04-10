defmodule MocWeb.MedalController do
  alias Moc.Medals
  use MocWeb, :controller

  def index(conn, _params) do
    medals = Medals.get_list()
    render(conn, :index, medals: medals)
  end

  def detail(conn, %{"id" => id}) do
    medal = Medals.get_medal(id)

    render(conn, :detail, medal: medal)
  end
end
