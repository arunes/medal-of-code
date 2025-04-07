defmodule Moc.Stats do
  import Ecto.Query
  alias Moc.Schema.Repository
  alias Moc.Repo

  def list_repositories() do
    from(rp in Repository,
      where: rp.sync_enabled == true,
      select: %{
        name: rp.name
      }
    )
    |> Repo.all()
    |> Enum.map(fn r -> r.name end)
  end
end
