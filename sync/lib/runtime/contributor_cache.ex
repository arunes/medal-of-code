defmodule Moc.Sync.Runtime.ContributorCache do
  @moduledoc """
  A cache for storing contributors, using an Agent to manage the state. Provides function for retrieving contributors by IDs.
  """

  @type t :: pid()

  @me __MODULE__
  use Agent
  import Ecto.Query
  alias Moc.Connector.Type
  alias Ecto.Repo.Schema
  alias Moc.Db.Repo
  alias Moc.Db.Schema

  def start_link(_) do
    Agent.start_link(&get_contributors/0, name: @me)
  end

  @doc """
  Gets the contributor db id by it's external id, creates the contributor if doesn't exists
  """
  @spec get_by_id(Type.contributor()) :: integer()
  def get_by_id(contributor) do
    Agent.get_and_update(@me, fn state ->
      case state[contributor.id] do
        nil ->
          new_id = create_contributor(contributor)
          {new_id, Map.put(state, contributor.id, new_id)}

        id ->
          {id, state}
      end
    end)
  end

  # Impl
  defp get_contributors() do
    query_contributor_ids()
    |> Repo.all()
    |> Enum.reduce(%{}, fn %{external_id: external_id, id: id}, acc ->
      Map.put(acc, external_id, id)
    end)
  end

  defp create_contributor(contributor) do
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

  # Queries
  defp query_contributor_ids do
    from(c in Schema.Contributor,
      select: %{
        id: c.id,
        external_id: c.external_id
      }
    )
  end
end
