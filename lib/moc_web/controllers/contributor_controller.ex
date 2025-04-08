defmodule MocWeb.ContributorController do
  alias Moc.Contributor
  use MocWeb, :controller

  def detail(conn, %{"id" => id}) do
    contributor = Contributor.get_contributor(id)

    render(conn, :detail, contributor: contributor)
  end
end
