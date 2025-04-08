defmodule MocWeb.ContributorController do
  alias Moc.Contributor
  use MocWeb, :controller

  def show(conn, %{"id" => id}) do
    contributor = Contributor.get_contributor(id)

    render(conn, :show, contributor: contributor)
  end
end
