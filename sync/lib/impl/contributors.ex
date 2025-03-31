defmodule Moc.Sync.Impl.Contributors do
  import Ecto.Query
  alias Ecto.Repo.Schema
  alias MocData.Repo
  alias MocData.Schema

  @spec get_contributors() :: %{String.t() => String.t()}
  def get_contributors() do
    query_contributor_ids()
    |> Repo.all()
    |> Enum.reduce(%{}, fn %{external_id: external_id, id: id}, acc ->
      Map.put(acc, external_id, id)
    end)
  end

  @spec create_contributor(Moc.Connector.Type.contributor()) :: integer()
  def create_contributor(contributor) do
    {:ok, resp} =
      Schema.Contributor.changeset(%Schema.Contributor{
        external_id: contributor.id,
        name: contributor.name,
        email: contributor.email,
        active: true
      })
      |> Repo.insert()

    resp.id
  end

  defp query_contributor_ids do
    from(c in Schema.Contributor,
      select: %{
        id: c.id,
        external_id: c.external_id
      }
    )
  end
end
