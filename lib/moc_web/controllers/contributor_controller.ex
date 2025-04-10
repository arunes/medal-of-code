defmodule MocWeb.ContributorController do
  alias Moc.Contributors
  use MocWeb, :controller

  def detail(conn, %{"id" => id}) do
    contributor = Contributors.get_contributor(id)

    render(conn, :detail, contributor: contributor)
  end
end
