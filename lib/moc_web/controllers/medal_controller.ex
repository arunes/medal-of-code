defmodule MocWeb.MedalController do
  alias Moc.Settings
  alias Moc.Medals
  use MocWeb, :controller

  def index(conn, _params) do
    medals = Medals.get_list()
    render(conn, :index, medals: medals)
  end

  def detail(conn, %{"id" => id}) do
    medal = Medals.get_medal(id)

    render(conn, :detail,
      medal: medal,
      winners: Medals.get_winners(id),
      settings: Settings.get(),
      current_contributor_id: 1
    )
  end
end
